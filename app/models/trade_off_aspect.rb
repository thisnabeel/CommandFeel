class TradeOffAspect < ApplicationRecord
    belongs_to :trade_off
    has_many :trade_off_aspect_contenders
    has_many :trade_off_contenders, through: :trade_off_aspect_contenders
end
