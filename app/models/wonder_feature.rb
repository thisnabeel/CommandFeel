class WonderFeature < ApplicationRecord
  belongs_to :wonder
  belongs_to :feature

  validates :wonder_id, presence: true
  validates :feature_id, presence: true
  validates :feature_id, uniqueness: { scope: :wonder_id }
end 