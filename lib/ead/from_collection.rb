module EAD

  module FromCollection

    def self.process(collection, records)
      gen = EAD::Generator.new

      records.each do |record|
        # TODO record as c01
      end

      # puts gen.to_xml
      gen.to_xml
    end

  end

end