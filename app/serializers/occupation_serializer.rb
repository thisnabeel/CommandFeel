class OccupationSerializer < ActiveModel::Serializer
  attributes :id, :title, :subtitle, :description, :average_salary_range,
             :created_at, :updated_at, :cohort_users_count, :occupation_skills

  def cohort_users_count
    object.cohort_users.count
  end

  def options
    instance_options[:serializer_options]
  end

  def occupation_skills
    if options && options[:occupation_skills] == true
      ActiveModelSerializers::SerializableResource.new(
        object.occupation_skills.includes(:skill).order(:position),
        each_serializer: OccupationSkillSerializer
      ).as_json
    else
      []
    end
  end
end
