class Record < ApplicationRecord
  belongs_to :collection

  has_many :interviews
  has_many :proofs
  # has_many :tapes

  has_many :activities
  has_many :summarizers, through: :activities
  has_many :catalogers, through: :activities
  has_many :inputters, through: :activities
  has_many :editors, through: :activities
  has_many :correctors, through: :activities
  has_many :producers, through: :activities

  alias_attribute :summary_by,   :summarizers
  alias_attribute :cataloged_by, :catalogers
  alias_attribute :input_by,     :inputters
  alias_attribute :edited_by,    :editors
  alias_attribute :corrected_by, :correctors
  alias_attribute :produced_by,  :producers
end
