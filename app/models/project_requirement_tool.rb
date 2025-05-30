class ProjectRequirementTool < ApplicationRecord
  belongs_to :project_requirement
  belongs_to :toolable, polymorphic: true

  validates :position, presence: true, numericality: { only_integer: true }
  validates :appropriate, inclusion: { in: [true, false] }
  validates :reason, presence: true
  validates :toolable_type, inclusion: { in: ['Wonder', 'Skill'] }
  validates :suggested_name, presence: true

  default_scope { order(position: :asc) }
end 