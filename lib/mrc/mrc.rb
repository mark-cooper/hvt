require 'marc'

module MRC

  ID_TAG = '910'
  ID_SUB = 'a'

  def self.create_records(records)
    records.each do |id, mrc|
      r = mrc # alias for convenience

      # create record
      record = Record.find(id) rescue nil
      record = Record.create!(id: id) unless record

      record.identifier          = MRC.subfield_value_for(r['910'],'b')
      record.title               = MRC.subfields_to_s(r['245'])
      record.extent_expression   = MRC.subfields_to_s(r['300'])
      record.abstract            = MRC.subfields_to_s(r['520'])
      record.citation            = MRC.subfields_to_s(r['524'])
      record.related_record_stmt = MRC.subfields_to_s(r['544'])
      record.identification_stmt = MRC.subfields_to_s(r['562'])

      record.has_mrc = true
      record.save
    end
  end

  def self.subfield_value_for(field, subfield)
    field[subfield] if field and field[subfield]
  end

  def self.subfields_to_s(field)
    field.map(&:value).join(' ').squeeze(' ') if field
  end

end