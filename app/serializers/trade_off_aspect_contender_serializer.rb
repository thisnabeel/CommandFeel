class TradeOffAspectContenderSerializer < ActiveModel::Serializer
  attributes :id, :trade_off_contender_id, :trade_off_aspect_id, :body
  belongs_to :trade_off_contender
end
