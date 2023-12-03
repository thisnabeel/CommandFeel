class TradeOffSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :header, :trade_off_id
  # attribute :skills

  has_many :trade_off_contenders

  attribute :trade_off_aspects, if: :include_aspects?

  def include_aspects?
    # Check if algorithms should be included based on the request
    @instance_options[:aspects]
  end


  def trade_off_aspects
    object.trade_off_aspects.map {|toa| TradeOffAspectSerializer.new(toa)}
  end

  # def skills
  #   Skill.find(object.trade_off_contenders.pluck(:skill_id))
  # end

end
