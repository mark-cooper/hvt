class CorporateAuthority < Authority
  has_many :terms
  has_many :records, through: :terms

  def self.element
    "corpname"
  end
end