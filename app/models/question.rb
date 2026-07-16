class Question < ApplicationRecord
  QUESTIONABLE_TYPES = %w[OccupationSkill CohortUser].freeze

  belongs_to :user
  belongs_to :last_comment_by, class_name: 'User', optional: true
  belongs_to :resolved_by, class_name: 'User', optional: true
  belongs_to :questionable, polymorphic: true
  has_many :question_comments, -> { order(:created_at) }, dependent: :destroy, inverse_of: :question

  validates :body, presence: true
  validates :questionable_type, inclusion: { in: QUESTIONABLE_TYPES }

  scope :newest_first, -> { order(updated_at: :desc) }
  scope :resolved, -> { where(resolved: true) }
  scope :unresolved, -> { where(resolved: false) }

  def unresolved?
    !resolved?
  end

  def resolve!(by:)
    update!(
      resolved: true,
      resolved_at: Time.current,
      resolved_by: by
    )
  end

  def reopen!
    update!(
      resolved: false,
      resolved_at: nil,
      resolved_by: nil
    )
  end

  def context_label
    case questionable
    when OccupationSkill
      questionable.display_title.presence || 'Skill'
    when CohortUser
      'General'
    else
      'Question'
    end
  end
end
