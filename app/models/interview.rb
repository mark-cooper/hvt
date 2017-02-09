class Interview < ApplicationRecord
  belongs_to :record
  has_many :agents
  has_many :interviewees, through: :agents
  has_many :interviewers, through: :agents
end
