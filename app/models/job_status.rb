class JobStatus < ApplicationRecord
  validates :job_type, presence: true
  validates :status, presence: true
  validates :started_at, presence: true

  scope :recent, -> { order(created_at: :desc).limit(100) }
  scope :running, -> { where(status: 'running') }
  scope :completed, -> { where(status: 'completed') }
  scope :failed, -> { where(status: 'failed') }

  def duration
    return nil unless started_at
    (completed_at || Time.current) - started_at
  end
end 