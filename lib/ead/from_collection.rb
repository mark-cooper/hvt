module EAD

  module FromCollection

    def self.process(collection)
      puts "Generating EAD for HVT #{collection.name}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      # collection specific
      # gen.eadid
      gen.set_title collection.name
      gen.author = EAD::HVT_AUTHOR
      gen.set_note(EAD::HVT_BIB, "bpg", collection.id, " ", "Orbis-bib")
      gen.unitid     = collection.id.to_s
      gen.unittitle  = collection.name

      dates = [collection.begin_date, collection.end_date].compact
      dates.each do |d|
        gen.unitdate = d rescue nil
      end

      gen.add_extent EAD.get_extent_for_collection(collection)

      rrcount = 0
      collection.records.where(has_mrc: true).includes([
        :interviews,
        :proofs,
        :tapes,
      ]).references(:interviews, :proofs, :tapes)
          .find_each(batch_size: 10).lazy.each do |record|
        rrcount += 1
        puts "Processing record #{rrcount.to_s}: HVT-#{record.id}"

        record_id     = "hvt_#{record.id}"
        c01           = gen.add_c01(record_id)
        c01.level     = "otherlevel"
        c01.unittitle = record.title

        dates = EAD.get_all_dates record
        dates.each do |d|
          c01.unitdate = d rescue nil
        end

        c01.add_extent EAD.get_extent_for_record(record)
        c01.add_extent("#{record.duration} Master Files", "duration", nil) if record.duration
        c01.abstract   = record.abstract if record.abstract
        c01.prefercite = record.citation if record.citation
        c01.add_odds([{ "Place of Recording" => record.publication_place }]) if record.publication_place
        c01.add_originations EAD.get_originations(record)
        c01.add_related_materials(EAD.get_related_materials(record), false)
        c01.add_authorities EAD.get_all_authorities(record)

        c01.accessrestrict = record.access_restriction ? record.access_restriction : EAD::HVT_RESTRICT_ACCESS_STMT
        c01.userestrict    = record.use_restriction ? "#{EAD::HVT_RESTRICT_USE_STMT}\n#{record.use_restriction}" : EAD::HVT_RESTRICT_USE_STMT

        grp_tapes = EAD.group_tapes_by_type(record)
        grp_tapes.each do |type, tapes|
          c02 = gen.add_c02_by_parent_id(record_id, EAD.random_id)
          EAD.handle_tapes_for c02, type, tapes
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end