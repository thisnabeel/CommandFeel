class FeatureDependency < ApplicationRecord
  belongs_to :feature
  belongs_to :dependable, polymorphic: true

  validates :feature_id, presence: true
  validates :dependable_type, presence: true
  validates :dependable_id, presence: true
  validates :usage, presence: true
  validates :dependable_id, uniqueness: { scope: [:feature_id, :dependable_type] }
end 