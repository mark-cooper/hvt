module EAD

  module FromRecords

    def self.process(collections)
      puts "Generating EAD for #{EAD::HVT_TITLE}"
      gen = EAD::Generator.new

      # boilerplate
      # TODO

      # records specific
      gen.set_title EAD::HVT_TITLE, "MS.1322", " "
      gen.unitid     = "1"
      gen.unittitle  = EAD::HVT_TITLE

      collections.each do |collection, records|
        puts "Processing collection #{collection.name}"
        collection_id  = EAD.id_for("hvt_#{collection.name}")
        c01 = gen.add_c01 collection_id
        c01.level = "series"
        c01.unittitle = collection.name

        records.each do |record|
          puts "Processing record #{record.id}"
          record_id     = "hvt_#{record.id}"
          c02           = gen.add_c02_by_parent_id(collection_id, record_id)
          c02.level     = "otherlevel"
          c02.unittitle = record.title

          grp_tapes = EAD.group_tapes_by_type(record)

          grp_tapes.each do |type, tapes|
            c03 = gen.add_c03_by_parent_id(record_id, EAD.id_for_recording_type(type, record.id))
            EAD.handle_tapes_for c03, type, tapes
          end
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end