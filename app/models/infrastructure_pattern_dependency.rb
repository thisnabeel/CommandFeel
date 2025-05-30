class InfrastructurePatternDependency < ApplicationRecord
  belongs_to :infrastructure_pattern
  belongs_to :dependable, polymorphic: true

  validates :infrastructure_pattern_id, presence: true
  validates :dependable_type, presence: true
  validates :dependable_id, presence: true
  validates :usage, presence: true
  validates :dependable_id, uniqueness: { scope: [:infrastructure_pattern_id, :dependable_type] }
end 