require 'marc'

module MRC

  ID_TAG = '910'
  ID_SUB = 'a'

  def self.add_authorities(record, mrc, authorities, tag, type, source)
    authorities[type] = {} unless authorities.has_key? type
    mrc.each_by_tag(tag) do |authority|
      authority_string = MRC.authority_string(authority)
      unless authorities[type].has_key?(authority_string)
        authorities[type][authority_string] = find_or_create_authority!(type, authority_string, source)
      end
      auth = authorities[type][authority_string]
      record.send(ActiveSupport::Inflector.pluralize(type).underscore).send(:push, auth)
    end
  end

  def self.authority_string(authority)
    authority.map(&:value).map(&:strip).join(" -- ")
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
      record.date_expression     = MRC.subfield_value_for(r['245'],'f')
      record.publication_date    = MRC.subfield_value_for(r['260'],'c')
      record.extent_expression   = MRC.subfields_to_s(r['300'])
      record.abstract            = MRC.subfields_to_s(r['520'])
      record.citation            = MRC.subfields_to_s(r['524'])
      record.related_record_stmt = MRC.subfields_to_s(r['544'])
      record.identification_stmt = MRC.subfields_to_s(r['562'])

      MRC.add_authorities(record, r, authorities, '600', 'PersonAuthority', 'lcsh')
      MRC.add_authorities(record, r, authorities, '610', 'CorporateAuthority', 'lcsh')
      MRC.add_authorities(record, r, authorities, '650', 'SubjectAuthority', 'lcsh')
      MRC.add_authorities(record, r, authorities, '651', 'GeographicAuthority', 'lcsh')
      MRC.add_authorities(record, r, authorities, '655', 'GenreAuthority', 'lcsh')
      MRC.add_authorities(record, r, authorities, '690', 'SubjectAuthority', 'local')
      MRC.add_authorities(record, r, authorities, '691', 'GeographicAuthority', 'local')
      MRC.add_authorities(record, r, authorities, '695', 'GenreAuthority', 'local')

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