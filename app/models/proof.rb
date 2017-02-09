class Proof < ApplicationRecord
  belongs_to :record
  has_many :agents
  has_many :proofers, through: :agents
end
