class Proof < ApplicationRecord
    belongs_to :user
    belongs_to :challenge
    has_many :proof_links, dependent: :destroy
end
