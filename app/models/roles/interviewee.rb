class Interviewee < Role
  has_many :agents
  has_many :interviews, through: :agents
end
