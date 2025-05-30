class InfrastructurePatternSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :visibility, :created_at, :updated_at
  
  has_many :wonder_infrastructure_patterns
  has_many :wonders
  has_many :infrastructure_pattern_dependencies
  
  def wonder_infrastructure_patterns
    return unless include_associations?
    object.wonder_infrastructure_patterns
  end

  def wonders
    return unless include_associations?
    object.wonders
  end

  def infrastructure_pattern_dependencies
    return unless include_associations?
    object.infrastructure_pattern_dependencies.map do |dependency|
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

  private

  def include_associations?
    @instance_options[:include_associations]
  end
end 