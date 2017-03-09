module EAD

  module FromRecord

    def self.process(record)
      gen = EAD::Generator.new
      gen.set_title record.title, "HVT.#{record.id}", " "
      gen.publisher = "Manuscripts and Archives"
      gen.address   = EAD::HVT_ADDRESS

      addr_last_idx = EAD::HVT_ADDRESS.count - 1
      path = gen.ead.eadheader.filedesc.publicationstmt.address.addressline(addr_last_idx)
      path.extptr.xlink_href  = EAD::HVT_URL
      path.extptr.xlink_show  = "new"
      path.extptr.xlink_title = EAD::HVT_URL
      path.extptr.xlink_type  = "simple"

      path               = gen.ead.eadheader.profiledesc
      path.creation      = "This finding aid was produced for ArchivesSpace using HVT (micro-app) on "
      path.creation.date = Time.now.to_s
      path.descrules     = "dacs"

      gen.set_language "English", "eng"
      gen.repository = "Manuscripts and Archives"
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title
      gen.prefercite = record.citation

      # physdec
      # unitdate

      originations = []
      originations << {
        type: "corpname", name: "Holocaust Survivors Film Project", role: "pro", source: "local"
      }

      record.interviews.each do |interview|
        interviewees = interview.interviewees.all.map {
          |i| { type: "persname", name: i[:name], role: "ive", source: "lcsh" }
        }

        interviewers = interview.interviewers.all.map {
          |i| { type: "persname", name: i[:name], role: "ivr", source: "lcsh" }
        }
        originations.concat interviewees
        originations.concat interviewers
      end

      gen.add_originations originations

      odds = []
      odds << { "Publication Date" => record.publication_date }
      odds << { "Summary" => record.abstract } if record.abstract
      gen.add_odds odds

      related_materials = []
      related_materials << { "Related Archival Materials" => record.related_record_stmt }
      related_materials << { "Copy and Version Identification" => record.identification_stmt }
      gen.add_related_materials related_materials

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

      tapes = Hash.new { |hash, key| hash[key] = [] }
      record.tapes.each do |tape|
        # group tapes by recording type
        # each distinct type is ONE c0*
        # each tape is a container element
        tapes[tape.recording_type] << tape
      end

      tapes.each do |type, tape|
        c01  = gen.add_c01(EAD.id_for_recording_type(type))
        path = c01.path
        path.level = "file"
        path.did.unittitle = type

        c01.add_extent "#{tape.count.to_s} Videocassettes (#{tape[0].format})"

        if tape[0].date
          c01.add_physfacet_date "Created from #{tape[0].source}, ", tape[0].date
        else
          c01.add_physfacet "Created from #{tape[0].source}."
        end

        tape.each do |t|
          c01.add_physfacet_corpname "Tape #{t.number.to_s}: ", t.manufacturer

          if t.shared_with > 0
            c01.add_physfacet "Tape #{t.number.to_s} is shared with HVT-#{t.shared_with.to_s} #{type} Tape 1."
          end
        end

        c01.add_containers(tape.map { |t| { id: t.id, barcode: t.barcode, number: t.number } })
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end