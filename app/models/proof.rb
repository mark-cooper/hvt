class Proof < ApplicationRecord
  belongs_to :record
  has_many :activities
  has_many :proofers, through: :activities
end
