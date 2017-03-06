module EAD

  module FromRecord

    def self.process(record)
      gen = EAD::Generator.new
      gen.set_title record.title, "HVT.#{record.id}", " "
      gen.publisher = "Manuscripts and Archives"
      gen.address   = EAD::HVT_ADDRESS

      addr_last_idx = EAD::HVT_ADDRESS.count - 1
      path = gen.ead.eadheader.filedesc.publicationstmt.address.addressline(addr_last_idx)
      path.extptr.xlink_href  = EAD::HVT_URL
      path.extptr.xlink_show  = "new"
      path.extptr.xlink_title = EAD::HVT_URL
      path.extptr.xlink_type  = "simple"

      path               = gen.ead.eadheader.profiledesc
      path.creation      = "This finding aid was produced using ArchivesSpace on "
      path.creation.date = Time.now.to_s
      path.descrules     = "dacs"

      gen.set_language "English", "eng"

      # puts gen.to_xml
      gen.to_xml
    end

  end

end