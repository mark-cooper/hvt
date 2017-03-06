module EAD

  module FromRecord

    def self.process(record)
      ead = EAD::Generator.new
      ead.set_title record.title

      # puts ead.to_xml
      ead.to_xml
    end

  end

end