module EAD

  module FromRecord

    def self.process(record)
      puts "Generating EAD for HVT #{record.id}: #{record.title}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      # record specific
      gen.eadid = "mssa.hvt.#{record.id.to_s.rjust(5, '0')}"
      gen.set_title record.title, "HVT.#{record.id}", " "
      gen.author = EAD::HVT_AUTHOR
      gen.set_note(EAD::HVT_BIB, "bpg", record.bib_id, " ", "Orbis-bib")
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title

      dates = EAD.get_all_dates record
      dates.each do |d|
        gen.unitdate = d rescue nil
      end

      gen.add_extent "#{record.extent.to_s} Videocassettes (#{record.stock})"

      gen.prefercite = record.citation if record.citation
      gen.add_originations EAD.get_originations(record)

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

      gen.add_authorities EAD.get_all_authorities(record)

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