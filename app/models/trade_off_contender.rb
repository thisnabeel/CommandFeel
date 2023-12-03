class TradeOffContender < ApplicationRecord
    belongs_to :trade_off
    has_many :trade_off_aspect_contenders
    has_many :trade_off_aspects, through: :trade_off_aspect_contenders
end