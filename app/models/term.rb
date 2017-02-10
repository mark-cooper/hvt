class Term < ApplicationRecord
  belongs_to :record
  belongs_to :authority
  belongs_to :subject_authority
  belongs_to :corporate_authority
end
