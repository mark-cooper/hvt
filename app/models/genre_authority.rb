class GenreAuthority < Authority
  has_many :terms
  has_many :records, through: :terms

  def self.element
    "genreform"
  end
end