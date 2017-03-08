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
      path.creation      = "This finding aid was produced using ArchivesSpace on "
      path.creation.date = Time.now.to_s
      path.descrules     = "dacs"

      gen.set_language "English", "eng"
      gen.repository = "Manuscripts and Archives"
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title
      gen.prefercite = record.citation

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
      # odds << { "Publication Date" => record.publication_date }
      odds << { "Summary" => record.abstract } if record.abstract
      gen.add_odds odds

      related_materials = []
      related_materials << { "Related Archival Materials" => record.related_record_stmt }
      related_materials << { "Copy and Version Identification" => record.identification_stmt }
      gen.add_related_materials related_materials

      authorities = []
      subjects = record.subject_authorities.all.map {
        |a| { type: SubjectAuthority.element, name: a[:name], source: a[:source] }
      }

      geognames = record.geographic_authorities.all.map {
        |a| { type: GeographicAuthority.element, name: a[:name], source: a[:source] }
      }

      genreforms = record.genre_authorities.all.map {
        |a| { type: GenreAuthority.element, name: a[:name], source: a[:source] }
      }

      persnames = record.person_authorities.all.map {
        |a| { type: PersonAuthority.element, name: a[:name], source: a[:source] }
      }

      corpnames = record.corporate_authorities.all.map {
        |a| { type: CorporateAuthority.element, name: a[:name], source: a[:source] }
      }

      authorities.concat subjects
      authorities.concat geognames
      authorities.concat genreforms
      authorities.concat persnames
      authorities.concat corpnames

      gen.add_authorities authorities

      # puts gen.to_xml
      gen.to_xml
    end

  end

end