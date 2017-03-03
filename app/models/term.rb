class Term < ApplicationRecord
  belongs_to :record
  belongs_to :authority
  belongs_to :subject_authority
  belongs_to :corporate_authority
  belongs_to :person_authority
  belongs_to :geographic_authority
  belongs_to :genre_authority
end
