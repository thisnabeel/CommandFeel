class PhraseLink < ApplicationRecord
  belongs_to :phrasable, polymorphic: true, optional: true
  belongs_to :phrase

  validates :phrase_id, presence: true
  validates :title, presence: true, if: -> { phrasable_type.nil? }
  validates :category, presence: true, if: -> { phrasable_type.nil? }
  validates :explanation, presence: true, if: -> { phrasable_type.nil? }
  
  # Only validate uniqueness of phrase_id with phrasable when phrasable is present
  validates :phrase_id, uniqueness: { scope: [:phrasable_type, :phrasable_id] }, if: -> { phrasable_type.present? }
end 