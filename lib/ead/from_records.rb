module EAD

  module FromRecords

    def self.process(collections)
      gen = EAD::Generator.new

      collections.each do |collection, records|
        # TODO collection c01

        records.each do |record|
          # TODO records c02
        end
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end