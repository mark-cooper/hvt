class Tape < ApplicationRecord
  has_one    :inventory_status
  belongs_to :record
end
