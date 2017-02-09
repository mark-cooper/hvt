class Producer < Role
  has_many :agents
  has_many :records, through: :agents
end