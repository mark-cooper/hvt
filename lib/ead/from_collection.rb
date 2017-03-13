module EAD

  module FromCollection

    def self.process(collection, records)
      gen = EAD::Generator.new

      # boilerplate
      # TODO

      # collection specific
      gen.set_title collection.name, "HVT.COLL.#{collection.id.to_s}", " "
      gen.unitid     = collection.id.to_s
      gen.unittitle  = collection.name

      records.each do |record|
        c01  = gen.add_c01("hvt_#{record.id}")
        c01.level = "otherlevel"
        c01.unittitle = record.title, "HVT.#{record.id}", " "

        grp_tapes = EAD.group_tapes_by_type(record)

        grp_tapes.each do |type, tapes|
          c02 = gen.add_c02_by_parent_id("hvt_#{record.id}", EAD.id_for_recording_type(type, record.id))
          EAD.handle_tapes_for c02, type, tapes
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end