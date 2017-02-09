class Activity < ApplicationRecord
  belongs_to :record
  belongs_to :interview
  belongs_to :proof
  belongs_to :agent
  belongs_to :cataloger
  belongs_to :corrector
  belongs_to :editor
  belongs_to :inputter
  belongs_to :producer
  belongs_to :proofer
  belongs_to :summarizer
  belongs_to :interviewee
  belongs_to :interviewer
end
