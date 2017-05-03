require "securerandom"
require_relative "from_collection"
require_relative "from_record"
require_relative "from_records"

module EAD

  HVT_ADDRESS = [
    "Yale University Library",
    "P.O. Box 208240",
    "New Haven, CT 06520-8240",
    "mssa.assist@yale.edu",
    "URL: ",
  ]
  HVT_AUTHOR = "compiled by Staff of the Fortunoff Video Archive for Holocaust Testimonies"
  HVT_BIB    = "This finding aid, which is compliant with the Yale EAD Best Practice Guidelines, Version 1.0., has a MARC record in Yale's ILS with the following bib number:"
  HVT_CONTAINER_PROFILES = {
    "1 inch" => "video (2 inch)",
    "35mm" => "film can (12d 2h 12w)",
    "Betacam SP" => "video Beta",
    "blank" => "videocassette",
    "Digital Betacam" => "video Beta",
    "DVCAM" => "video DV",
    "DVD" => "DVD Case",
    "Hard Drive" => "card box (6d 4h 7w)",
    "Hi8" => "video Hi-8",
    "MiniDV" => "video DV",
    "U-Matic" => "U-matic",
    "VHS" => "video VHS",
    nil => "videocassette",
  }
  HVT_RESTRICT_ACCESS_STMT = "This testimony is open with permission."
  HVT_RESTRICT_USE_STMT = "Copyright has been transferred to the Fortunoff Video Archive for Holocaust Testimonies. Use of this testimony requires permission of the Fortunoff Video Archive."
  HVT_TITLE  = "Fortunoff Video Archive of Holocaust Testimonies"
  HVT_TYPE_SUFFIX = {
    "Duplicate" => "D",
    "Licensing copy" => "LC",
    "Restoration master" => "RM",
    "Restoration submaster" => "RS",
    "Submaster" => "S",
    "Use copy" => "U",
  }
  HVT_URL = "http://www.library.yale.edu/mssa/"

  def self.add_boilerplate(ead)
    # boilerplate
    ead.publisher = "Manuscripts and Archives"
    ead.address   = EAD::HVT_ADDRESS

    addr_last_idx = EAD::HVT_ADDRESS.count - 1
    path = ead.ead.eadheader.filedesc.publicationstmt.address.addressline(addr_last_idx)
    path.extptr.xlink_href  = EAD::HVT_URL
    path.extptr.xlink_show  = "new"
    path.extptr.xlink_title = EAD::HVT_URL
    path.extptr.xlink_type  = "simple"

    ead.set_create_date(Time.now.to_s, "This finding aid was produced for ArchivesSpace using HVT (micro-app) on ")
    ead.descrules = "dacs"

    ead.set_language "English", "eng"
    ead.repository = "Manuscripts and Archives"
  end

  # subjects = EAD.get_authorities(record, SubjectAuthority, :subject_authorities) etc.
  def self.get_authorities(record, klass, association_method)
    record.send(association_method).all.map {
      |a| { type: klass.element, name: a[:name], source: a[:source] }
    }
  end

  def self.get_all_authorities(record)
    authorities = []

    subjects   = EAD.get_authorities(record, SubjectAuthority, :subject_authorities)
    geognames  = EAD.get_authorities(record, GeographicAuthority, :geographic_authorities)
    genreforms = EAD.get_authorities(record, GenreAuthority, :genre_authorities)
    persnames  = EAD.get_authorities(record, PersonAuthority, :person_authorities)
    corpnames  = EAD.get_authorities(record, CorporateAuthority, :corporate_authorities)

    authorities.concat subjects
    authorities.concat geognames
    authorities.concat genreforms
    authorities.concat persnames
    authorities.concat corpnames

    authorities
  end

  def self.get_all_dates(record)
    # try to get all the dates we have ...
    dates = record.date_expression.split(" and ") rescue []
    dates = dates.map do |d|
      begin
        Date.parse(d).to_date.to_s if d =~ /\d{4}/
      rescue
        d =~ /^\d{4}\.?/ ? d[0..3] : nil
      end
    end
    dates = dates.concat(record.interviews.map{ |i|
      i[:date] ? i[:date].to_date.to_s : nil
    }).compact.sort.uniq
    dates
  end

  def self.get_extent_for_collection(collection)
    collection.extent > 0 ? "#{collection.extent.to_s} Videocassettes" : "0 Videocassettes"
  end

  def self.get_extent_for_record(record)
    stock = (record.stock and !record.stock.empty?) ? " (#{record.stock})" : ""
    record.extent > 0 ? "#{record.extent.to_s} Videocassettes#{stock}" : "0 Videocassettes"
  end

  def self.get_originations(record)
    originations = []
    originations << {
      type: "corpname", name: record.primary_source.gsub(/,$/, ''), role: "pro", source: "local"
    } if record.primary_source

    originations << {
      type: "corpname", name: record.secondary_source, role: "pro", source: "local"
    } if record.secondary_source

    record.interviews.each do |interview|
      interviewees = interview.interviewees.all.map {
        |i| {
          type: "persname",
          name: EAD.redact_name(i[:name]),
          role: "ive",
          source: "local_mssa",
          authorized_form: i[:name],
        }
      }

      interviewers = interview.interviewers.all.map {
        |i| { type: "persname", name: i[:name], role: "ivr", source: "local_mssa" }
      }
      originations.concat interviewees
      originations.concat interviewers
    end
    originations.uniq { |origination| origination.values_at(:name, :role) }
  end

  def self.get_related_materials(record)
    related_materials = []
    related_materials << {
      "Related Archival Materials" => record.related_record_stmt
    } if record.related_record_stmt

    related_materials << {
      "Copy and Version Identification" => record.identification_stmt
    } if record.identification_stmt
    related_materials
  end

  def self.group_tapes_by_type(record)
    tapes = Hash.new { |hash, key| hash[key] = [] }
    # want tapes in this order ...
    [
      "Master",
      "Camera",
      "Duplicate",
      "Submaster",
      "Restoration master",
      "Restoration submaster",
      "Field acquisition (master)",
      "Licensing copy",
      "Use copy",
      "Digital Betacam Home",
      "Digital Betacam M&E",
      "Digital Betacam PBS",
    ].each do |type|
      record.tapes.where(recording_type: type).each do |tape|
        tapes[type] << tape
      end
    end
    tapes
  end

  def self.handle_tapes_for(component, type, tapes)
    component.level = "file"
    component.unittitle = type

    component.add_extent "#{tapes.count.to_s} Videocassettes (#{tapes[0].format})"

    if tapes[0].date
      component.add_physfacet_date "Created from #{tapes[0].source}, ", tapes[0].date.to_date.to_s
    else
      component.add_physfacet "Created from #{tapes[0].source}."
    end

    tapes.each do |t|
      if t.manufacturer and not t.manufacturer.empty?
        component.add_physfacet_corpname "Tape #{t.number.to_s} (#{t.barcode}): ", t.manufacturer
      else
        component.add_physfacet "Tape #{t.number.to_s} (#{t.barcode})."
      end

      # REDUNDANT: use instance link for relationship
      # if t.shared_with > 0
      #   component.add_physfacet "Tape #{t.number.to_s} is shared with HVT-#{t.shared_with.to_s} #{type} Tape 1."
      # end
    end

    component.add_containers(
      tapes.map { |t|
        {
          id: t.id,
          barcode: t.barcode,
          number: EAD.number_for_recording_type(type, t.number),
          profile: EAD::HVT_CONTAINER_PROFILES[t.format],
        }
      }
    )
  end

  def self.id_for(value)
    value.downcase.gsub(/\s/, '_')
  end

  # EAD.id_for_recording_type(tape.recording_type)
  def self.id_for_recording_type(recording_type, prefix = nil, strip_chars = '(\(|\)|&)')
    recording_type = "#{prefix.to_s}_#{recording_type}" if prefix
    recording_type = recording_type.gsub(/#{strip_chars}/, '') if recording_type =~ /#{strip_chars}/
    EAD.id_for recording_type
  end

  def self.number_for_recording_type(type, number)
    HVT_TYPE_SUFFIX.has_key?(type) ? "#{number.to_s}#{HVT_TYPE_SUFFIX[type]}" : number.to_s
  end

  def self.random_id
    SecureRandom.hex
  end

  def self.redact_name(name)
    redacted = name
    if name =~ /,/
      last_name, rest = name.split(",")
      redacted = [last_name[0], rest].join(",")
    end
    redacted
  end

end