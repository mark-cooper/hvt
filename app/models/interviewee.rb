class Interviewee < Agent
  has_many :activities
  has_many :interviews, through: :activities
end
