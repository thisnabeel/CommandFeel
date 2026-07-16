class CohortUserSerializer < ActiveModel::Serializer
  attributes :id, :cohort_id, :user_id, :occupation_id, :status,
             :created_at, :updated_at, :occupation_title, :user_email, :user_username,
             :cohort_title, :cohort_subtitle, :cohort_description,
             :cohort_start_date, :cohort_end_date,
             :cohort_sprints_count, :cohort_sprints

  def occupation_title
    object.occupation&.title
  end

  def user_email
    object.user&.email
  end

  def user_username
    object.user&.username
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

  def cohort_sprints_count
    object.cohort&.sprints_count
  end

  def cohort_sprints
    return [] unless object.cohort

    object.cohort.cohort_sprints.ordered.map do |sprint|
      CohortSprintSerializer.new(sprint).as_json
    end
  end
end
