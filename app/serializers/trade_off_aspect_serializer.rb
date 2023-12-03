class TradeOffAspectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :position, :trade_off_id
  attributes :contenders

  def contenders
    object.trade_off_aspect_contenders.map {|toa| TradeOffAspectContenderSerializer.new(toa)}
  end
end
