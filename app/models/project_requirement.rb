class ProjectRequirement < ApplicationRecord
  belongs_to :wonder
  has_many :project_requirement_tools, -> { order(position: :asc) }, dependent: :destroy

  validates :title, presence: true
  validates :position, presence: true, numericality: { only_integer: true }

  default_scope { order(position: :asc) }
end 