class Proof < ApplicationRecord
  belongs_to :record
  has_one :proofer
end
