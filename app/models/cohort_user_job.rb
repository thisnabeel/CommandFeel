class CohortUserJob < ApplicationRecord
  belongs_to :cohort_user

  validates :title, presence: true
  validates :url, presence: true
  validate :url_must_be_http

  scope :active, -> { where(archive: false) }
  scope :ordered, -> { order(:position, :id) }

  before_validation :set_position, on: :create

  private

  def set_position
    return if position.present? && position.positive?

    max = cohort_user&.cohort_user_jobs&.maximum(:position) || 0
    self.position = max + 1
  end

  def url_must_be_http
    return if url.blank?

    uri = URI.parse(url)
    return if uri.is_a?(URI::HTTP) && uri.host.present?

    errors.add(:url, 'must be a valid http or https link')
  rescue URI::InvalidURIError
    errors.add(:url, 'must be a valid http or https link')
  end
end
