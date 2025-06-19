class QuestSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :image_url, :difficulty, :created_at, :updated_at, :steps, :questable

  def steps
    if include_choices?
      object.quest_steps.order(:position).map {|step| QuestStepSerializer.new(step)}
    else
      object.quest_steps.order(:position)
    end
  end

  def questable
    object.questable
  end

  def include_choices?
    @instance_options[:include_choices]
  end
end 