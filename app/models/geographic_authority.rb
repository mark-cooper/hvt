class GeographicAuthority < Authority
  has_many :terms
  has_many :records, through: :terms

  def self.element
    "geogname"
  end
end