class Interview < ApplicationRecord
  belongs_to :record
  has_many :activities
  has_many :interviewees, through: :activities
  has_many :interviewers, through: :activities
end
