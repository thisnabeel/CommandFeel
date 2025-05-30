class Feature < ApplicationRecord
  has_many :wonder_features, dependent: :destroy
  has_many :wonders, through: :wonder_features
  
  has_many :feature_dependencies, dependent: :destroy
  has_many :skills, through: :feature_dependencies, source: :dependable, source_type: 'Skill'
  has_many :wonder_dependencies, through: :feature_dependencies, source: :dependable, source_type: 'Wonder'

  validates :title, presence: true
end 