module EAD

  module FromCollection

    def self.process(collection, records)
      puts "Generating EAD for HVT #{collection.name}"
      gen = EAD::Generator.new
      EAD.add_boilerplate gen

      rrcount = 0

      # collection specific
      gen.set_title collection.name, "HVT.COLL.#{collection.id.to_s}", " "
      gen.unitid     = collection.id.to_s
      gen.unittitle  = collection.name

      records.each do |record|
        rrcount += 1
        puts "Processing record #{rrcount.to_s}: HVT-#{record.id}"
        record_id     = "hvt_#{record.id}"
        c01           = gen.add_c01(record_id)
        c01.level     = "otherlevel"
        c01.unittitle = record.title

        c01.prefercite = record.citation if record.citation
        c01.add_originations EAD.get_originations(record)

        c01.add_authorities EAD.get_all_authorities(record)

        grp_tapes = EAD.group_tapes_by_type(record)
        grp_tapes.each do |type, tapes|
          c02 = gen.add_c02_by_parent_id(record_id, EAD.id_for_recording_type(type, record.id))
          EAD.handle_tapes_for c02, type, tapes
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end