class Quiz < ApplicationRecord
  belongs_to :quizable, polymorphic: true
end
