class Term < ApplicationRecord
  belongs_to :record
  belongs_to :authority
  belongs_to :subject
end
