class OccupationSkillEvidenceSerializer < ActiveModel::Serializer
  attributes :id, :body, :approved, :comment, :user_id, :occupation_skill_id, :cohort_id,
             :user_display_name, :skill_label, :breadcrumb, :occupation_title,
             :cohort_title, :cohort_subtitle, :cohort_description,
             :cohort_start_date, :cohort_end_date, :evidence_bullets,
             :created_at, :updated_at

  def user_display_name
    u = object.user
    return nil unless u

    name = [u.first_name, u.last_name].map { |p| p.to_s.strip }.reject(&:blank?).join(' ')
    name.presence || u.username.presence || u.email
  end

  def skill_label
    object.occupation_skill&.display_title.presence || 'Skill'
  end

  def breadcrumb
    object.occupation_skill&.breadcrumb
  end

  def occupation_title
    object.occupation_skill&.occupation&.title
  end

  def cohort_title
    object.cohort&.title
  end

  def cohort_subtitle
    object.cohort&.subtitle
  end

  def cohort_description
    object.cohort&.description
  end

  def cohort_start_date
    object.cohort&.start_date
  end

  def cohort_end_date
    object.cohort&.end_date
  end

  def evidence_bullets
    scope = if object.association(:evidence_bullets).loaded?
              object.evidence_bullets.sort_by { |b| [b.position || 0, b.id] }
            else
              object.evidence_bullets.ordered
            end

    scope.map { |b| EvidenceBulletSerializer.new(b).as_json }
  end
end
