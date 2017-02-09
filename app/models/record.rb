class Record < ApplicationRecord
  has_many :interviews
  has_many :proofs
  # has_many :tapes

  has_many :agents
  has_many :summarizers, through: :agents
  has_many :catalogers, through: :agents
  has_many :inputters, through: :agents
  has_many :editors, through: :agents
  has_many :correctors, through: :agents
  has_many :producers, through: :agents

  alias_attribute :summary_by,   :summarizers
  alias_attribute :cataloged_by, :catalogers
  alias_attribute :input_by,     :inputters
  alias_attribute :edited_by,    :editors
  alias_attribute :corrected_by, :correctors
  alias_attribute :produced_by,  :producers
end
