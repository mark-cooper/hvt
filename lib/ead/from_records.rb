module EAD

  module FromRecords

    def self.process(collections)
      puts "Generating EAD for #{EAD::HVT_TITLE}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      # records specific
      gen.set_title EAD::HVT_TITLE
      gen.unitid     = "MS.1322"
      gen.unittitle  = EAD::HVT_TITLE

      ccount = 0
      rcount = 0
      collections.each do |collection|
        ccount += 1
        puts "Processing collection #{ccount.to_s}: #{collection.name}"
        collection_id  = EAD.id_for("hvt_#{collection.name}")
        c01 = gen.add_c01 collection_id
        c01.level = "series"
        c01.unittitle = collection.name

        collection.records.where(has_mrc: true).includes([
          :interviews,
          :proofs,
          :tapes,
        ]).references(:interviews, :proofs, :tapes)
            .find_each(batch_size: 10).lazy.each do |record|
          rcount += 1
          puts "Processing record #{rcount.to_s}: HVT-#{record.id}"
          record_id     = "hvt_#{record.id}"
          c02           = gen.add_c02_by_parent_id(collection_id, record_id)
          c02.level     = "otherlevel"
          c02.unittitle = record.title

          dates = EAD.get_all_dates record
          dates.each do |d|
            c02.unitdate = d rescue nil
          end

          odds = []
          odds << { "Place of Recording" => record.publication_place } if record.publication_place
          odds << { "Length of Recording" => record.duration } if record.duration

          c02.add_extent EAD.get_extent_for_record(record)
          c02.abstract   = record.abstract if record.abstract
          c02.prefercite = record.citation if record.citation
          c02.add_odds odds
          c02.add_originations EAD.get_originations(record)
          c02.add_related_materials(EAD.get_related_materials(record), false)
          c02.add_authorities EAD.get_all_authorities(record)

          c02.accessrestrict = record.access_restriction ? record.access_restriction : EAD::HVT_RESTRICT_ACCESS_STMT
          c02.userestrict    = record.use_restriction ? "#{EAD::HVT_RESTRICT_USE_STMT}\n#{record.use_restriction}" : EAD::HVT_RESTRICT_USE_STMT

          grp_tapes = EAD.group_tapes_by_type(record)
          grp_tapes.each do |type, tapes|
            c03 = gen.add_c03_by_parent_id(record_id, EAD.random_id)
            EAD.handle_tapes_for c03, type, tapes
          end
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end