class Phrase < ApplicationRecord
  has_many :phrase_links, dependent: :destroy
  has_many :skills, through: :phrase_links, source: :phrasable, source_type: 'Skill'
  has_many :wonders, through: :phrase_links, source: :phrasable, source_type: 'Wonder'

  validates :body, presence: true
  validates :role, presence: true
end 