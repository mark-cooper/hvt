module EAD

  module FromCollection

    def self.process(collection, records)
      ead = EAD::Generator.new

      records.each do |record|
        # TODO record as c01
      end

      # puts ead.to_xml
      ead.to_xml
    end

  end

end