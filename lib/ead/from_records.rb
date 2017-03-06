module EAD

  module FromRecords

    def self.process(collections)
      ead = EAD::Generator.new

      collections.each do |collection, records|
        # TODO collection c01

        records.each do |record|
          # TODO records c02
        end
      end

      # puts ead.to_xml
      ead.to_xml
    end

  end

end