class Record < ApplicationRecord
  has_many :interviews

  has_one :summarizer
  has_one :cataloger
  has_one :inputter
  has_one :editor
  has_one :corrector
  has_one :producer

  alias_attribute :summary_by,   :summarizer
  alias_attribute :cataloged_by, :cataloger
  alias_attribute :input_by,     :inputter
  alias_attribute :edited_by,    :editor
  alias_attribute :corrected_by, :corrector
  alias_attribute :produced_by,  :producer
end
