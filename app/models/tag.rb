class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  
  # Define polymorphic associations for each taggable type
  has_many :skills, through: :taggings, source: :taggable, source_type: 'Skill'
  has_many :wonders, through: :taggings, source: :taggable, source_type: 'Wonder'
  has_many :code_comparisons, through: :taggings, source: :taggable, source_type: 'CodeComparison'

  validates :title, presence: true, uniqueness: true
end 