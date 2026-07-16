class EvidenceBullet < ApplicationRecord
  belongs_to :occupation_skill_evidence

  validates :body, presence: true

  scope :ordered, -> { order(:position, :id) }

  before_validation :set_position, on: :create

  private

  def set_position
    return if position.present? && position.positive?

    max = occupation_skill_evidence&.evidence_bullets&.maximum(:position) || 0
    self.position = max + 1
  end
end
