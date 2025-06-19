class ResumePoint < ApplicationRecord
  belongs_to :challenge

  validates :body, presence: true
  validates :position, presence: true

  before_validation :set_position, on: :create

  private

  def set_position
    return if position.present?
    self.position = (challenge.resume_points.maximum(:position) || 0) + 1
  end
end 