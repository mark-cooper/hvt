class Subject < Authority
  has_many :terms
  has_many :records, through: :terms

  def self.element
    "subject"
  end
end
