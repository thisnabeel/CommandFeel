class OccupationSkill < ApplicationRecord
  belongs_to :occupation
  belongs_to :skill, optional: true
  belongs_to :occupation_skill, optional: true
  has_many :occupation_skills, dependent: :destroy
  has_many :occupation_skill_user_notes, dependent: :destroy
  has_many :questions, as: :questionable, dependent: :destroy
  has_many :occupation_skill_evidences, dependent: :destroy

  def display_title
    skill&.title.presence || title
  end

  # Parent chain via occupation_skill nesting, leaf last — e.g. "Testing › Regression Testing"
  def breadcrumb
    titles = []
    node = self
    seen = {}
    while node
      break if seen[node.id]

      seen[node.id] = true
      titles.unshift(node.display_title.to_s)
      node = node.occupation_skill
    end
    titles.join(' › ')
  end
end
