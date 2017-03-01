require 'marc'

module MRC

  ID_TAG = '910'
  ID_SUB = 'a'

  def self.add_authorities(record, mrc, authorities, tag, type, source)
    mrc.each_by_tag(tag) do |authority|
      unless authorities.has_key?(authority.to_s)
        authorities[authority.to_s] = find_or_create_authority!(type, authority.to_s, source)
      end
      auth = authorities[authority.to_s]
      record.send(ActiveSupport::Inflector.pluralize(type).underscore).send(:push, auth)
    end
  end

  def self.create_records(records)
    authorities = {}

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

      MRC.add_authorities(record, r, authorities, '650', 'SubjectAuthority', 'lcsh')

      record.has_mrc = true
      record.save
    end
  end

  def self.find_or_create_authority!(type, name, source)
    authority = Authority.where(type: type, name: name, source: source)
    if authority.any?
      authority = authority.first
    else
      authority = Authority.create!(type: type, name: name, source: source)
    end
    authority
  end

  def self.subfield_value_for(field, subfield)
    field[subfield] if field and field[subfield]
  end

  def self.subfields_to_s(field)
    field.map(&:value).join(' ').squeeze(' ') if field
  end

end