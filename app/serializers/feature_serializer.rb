class FeatureSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :visibility, :created_at, :updated_at
  
  has_many :wonder_features
  has_many :wonders
  has_many :feature_dependencies
  
  def feature_dependencies
    object.feature_dependencies.map do |dependency|
      {
        id: dependency.id,
        dependable_type: dependency.dependable_type,
        dependable_id: dependency.dependable_id,
        usage: dependency.usage,
        position: dependency.position,
        dependable: case dependency.dependable_type
                   when 'Skill'
                     SkillSerializer.new(dependency.dependable)
                   when 'Wonder'
                     WonderSerializer.new(dependency.dependable)
                   end
      }
    end
  end
end 