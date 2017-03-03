class PersonAuthority < Authority
  has_many :terms
  has_many :records, through: :terms

  def self.element
    "persname"
  end
end