class TradeOff < ApplicationRecord
    has_many :trade_offs
    has_many :trade_off_aspects
    has_many :trade_off_contenders
    belongs_to :trade_off, optional: true
end
