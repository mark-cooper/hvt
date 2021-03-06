module EAD

  module FromRecord

    def self.process(record)
      puts "Generating EAD for HVT #{record.id}: #{record.title}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      # record specific
      gen.eadid = "mssa.hvt.#{record.id.to_s.rjust(4, '0')}"

      # TODO: if revisiting refactor into EAD.add_titles(gen, record)
      if record.title =~ /Holocaust testimony$/
        gen.set_formal_title "Guide to the #{record.title}"
        title_parts  = record.title.split(".")
        if title_parts.count > 1
          names          = title_parts.shift.split(" ")
          first_initial  = names.find { |tp| tp.length == 1 }
          names.delete first_initial
          reformed_names = "#{first_initial}., #{names.join(' ')}"
          title_parts.unshift reformed_names
          filing_title   = title_parts.join(' ').squeeze('  ')
        else
          filing_title = record.title
        end
        gen.set_filing_title filing_title
      else
        gen.set_title record.title
      end

      gen.author = EAD::HVT_AUTHOR
      gen.set_note(EAD::HVT_BIB, "bpg", record.bib_id, " ", "Orbis-bib")
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title

      dates = EAD.get_all_dates record
      dates.each do |d|
        gen.unitdate = d rescue nil
      end

      odds = []
      odds << { "Place of Recording" => record.publication_place } if record.publication_place
      odds << { "Length of Recording" => record.duration } if record.duration

      gen.add_extent EAD.get_extent_for_record(record)
      gen.abstract   = record.abstract if record.abstract
      gen.prefercite = record.citation if record.citation
      gen.add_odds odds
      gen.add_originations EAD.get_originations(record)
      gen.add_related_materials(EAD.get_related_materials(record), false)
      gen.add_authorities EAD.get_all_authorities(record)

      gen.accessrestrict = record.access_restriction ? record.access_restriction : EAD::HVT_RESTRICT_ACCESS_STMT
      gen.userestrict    = record.use_restriction ? "#{EAD::HVT_RESTRICT_USE_STMT}\n#{record.use_restriction}" : EAD::HVT_RESTRICT_USE_STMT

      grp_tapes = EAD.group_tapes_by_type(record)
      grp_tapes.each do |type, tapes|
        next if type.nil? or type.empty?
        c01  = gen.add_c01(EAD.random_id)
        EAD.handle_tapes_for c01, type, tapes
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end