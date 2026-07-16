class CohortSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :sprints_count, :title, :subtitle,
             :video_url, :description, :created_at, :updated_at, :cohort_sprints

  def cohort_sprints
    object.cohort_sprints.ordered.map do |sprint|
      CohortSprintSerializer.new(sprint).as_json
    end
  end
end
