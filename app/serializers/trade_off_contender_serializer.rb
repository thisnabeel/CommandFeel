class TradeOffContenderSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :trade_off_id, :description, :skill_id

end
