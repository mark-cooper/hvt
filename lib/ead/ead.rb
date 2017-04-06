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
  HVT_BIB   = "This finding aid, which is compliant with the Yale EAD Best Practice Guidelines, Version 1.0., has a MARC record in Yale's ILS with the following bib number:"
  HVT_TITLE = "Fortunoff Video Archive of Holocaust Testimonies"
  HVT_TYPE_SUFFIX = {
    "Duplicate" => "D",
    "Licensing copy" => "LC",
    "Restoration master" => "RM",
    "Restoration submaster" => "RS",
    "Submaster" => "S",
    "Use copy" => "U",
  }
  HVT_URL   = "http://www.library.yale.edu/mssa/"

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
        Date.parse(d).to_date.to_s
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
    # TODO
  end

  def self.get_extent_for_record(record)
    record.extent > 0 ? "#{record.extent.to_s} Videocassettes (#{record.stock})" : "0 Videocassettes"
  end

  def self.get_originations(record)
    originations = []
    originations << {
      type: "corpname", name: "Holocaust Survivors Film Project", role: "pro", source: "local"
    }

    record.interviews.each do |interview|
      interviewees = interview.interviewees.all.map {
        |i| { type: "persname", name: i[:name], role: "ive", source: "local_mssa" }
      }

      interviewers = interview.interviewers.all.map {
        |i| { type: "persname", name: i[:name], role: "ivr", source: "local_mssa" }
      }
      originations.concat interviewees
      originations.concat interviewers
    end
    originations
  end

  def self.group_tapes_by_type(record)
    tapes = Hash.new { |hash, key| hash[key] = [] }
    record.tapes.each do |tape|
      # group tapes by recording type
      # each distinct type is ONE c0*
      # each tape is a container element
      tapes[tape.recording_type] << tape
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
      component.add_physfacet_corpname "Tape #{t.number.to_s}: ", t.manufacturer

      if t.shared_with > 0
        component.add_physfacet "Tape #{t.number.to_s} is shared with HVT-#{t.shared_with.to_s} #{type} Tape 1."
      end
    end

    component.add_containers(
      tapes.map { |t|
        { id: t.id, barcode: t.barcode, number: EAD.number_for_recording_type(type, t.number) }
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

end