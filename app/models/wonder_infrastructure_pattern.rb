class WonderInfrastructurePattern < ApplicationRecord
  belongs_to :wonder
  belongs_to :infrastructure_pattern

  validates :wonder_id, presence: true
  validates :infrastructure_pattern_id, presence: true
  validates :infrastructure_pattern_id, uniqueness: { scope: :wonder_id }
end 