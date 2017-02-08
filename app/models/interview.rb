class Interview < ApplicationRecord
  belongs_to :record
  has_many :interviewees
  has_many :interviewers
end
