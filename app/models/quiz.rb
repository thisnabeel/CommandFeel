class Quiz < ApplicationRecord
  belongs_to :quizable, polymorphic: true
  has_many :quiz_choices
end
