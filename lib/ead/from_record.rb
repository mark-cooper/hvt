module EAD

  module FromRecord

    def self.process(record)
      puts "Generating EAD for HVT #{record.id}: #{record.title}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      # record specific
      gen.eadid = "mssa.hvt.#{record.id.to_s.rjust(4, '0')}"
      gen.set_title record.title
      gen.author = EAD::HVT_AUTHOR
      gen.set_note(EAD::HVT_BIB, "bpg", record.bib_id, " ", "Orbis-bib")
      gen.unitid     = "HVT-#{record.id}"
      gen.unittitle  = record.title

      dates = EAD.get_all_dates record
      dates.each do |d|
        gen.unitdate = d rescue nil
      end

      gen.add_extent EAD.get_extent_for_record(record)
      gen.add_extent("#{record.duration} Master Files", "duration", nil) if record.duration
      gen.abstract   = record.abstract if record.abstract
      gen.prefercite = record.citation if record.citation
      gen.add_odds([{ "Place of Recording" => record.publication_place }]) if record.publication_place
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