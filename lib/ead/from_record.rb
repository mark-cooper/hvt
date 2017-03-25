module EAD

  module FromRecord

    def self.process(record)
      puts "Generating EAD for HVT #{record.id}: #{record.title}"
      gen = EAD::Generator.new

      # boilerplate
      gen.publisher = "Manuscripts and Archives"
      gen.address   = EAD::HVT_ADDRESS

      addr_last_idx = EAD::HVT_ADDRESS.count - 1
      path = gen.ead.eadheader.filedesc.publicationstmt.address.addressline(addr_last_idx)
      path.extptr.xlink_href  = EAD::HVT_URL
      path.extptr.xlink_show  = "new"
      path.extptr.xlink_title = EAD::HVT_URL
      path.extptr.xlink_type  = "simple"

      gen.set_create_date(Time.now.to_s, "This finding aid was produced for ArchivesSpace using HVT (micro-app) on ")
      gen.descrules = "dacs"

      gen.set_language "English", "eng"
      gen.repository = "Manuscripts and Archives"

      # record specific
      gen.eadid = "mssa.hvt.#{record.id.to_s.rjust(5, '0')}"
      gen.set_title record.title, "HVT.#{record.id}", " "
      gen.author = EAD::HVT_AUTHOR
      gen.set_note(EAD::HVT_BIB, "bpg", record.bib_id, " ", "Orbis-bib")
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title

      # try to get all the dates we have ...
      dates = record.date_expression.split(" and ").map { |d| Date.parse(d).to_date.to_s } rescue []
      dates = dates.concat(record.interviews.map{ |i|
        i[:date] ? i[:date].to_date.to_s : nil
      }).compact.sort.uniq
      dates.each do |d|
        gen.unitdate = d rescue nil
      end

      gen.add_extent "#{record.extent.to_s} Videocassettes (#{record.stock})"

      gen.prefercite = record.citation if record.citation

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

      gen.add_originations originations

      odds = []
      odds << { "Publication Date" => record.publication_date } if record.publication_date
      odds << { "Summary" => record.abstract } if record.abstract
      gen.add_odds odds, false

      related_materials = []
      related_materials << {
        "Related Archival Materials" => record.related_record_stmt
      } if record.related_record_stmt

      related_materials << {
        "Copy and Version Identification" => record.identification_stmt
      } if record.identification_stmt

      gen.add_related_materials related_materials, false

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

      gen.add_authorities authorities

      grp_tapes = EAD.group_tapes_by_type(record)

      grp_tapes.each do |type, tapes|
        next if type.nil? or type.empty?
        c01  = gen.add_c01(EAD.id_for_recording_type(type))
        EAD.handle_tapes_for c01, type, tapes
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end