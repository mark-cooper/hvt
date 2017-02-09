class Corrector < Agent
  has_many :activities
  has_many :records, through: :activities
end