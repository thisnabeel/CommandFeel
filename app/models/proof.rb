class Proof < ApplicationRecord
    belongs_to :user
    belongs_to :proofable, polymorphic: true, optional: true
    has_many :proof_links, dependent: :destroy
end
