class Challenge < ApplicationRecord
    belongs_to :challengeable, polymorphic: true
	# has_many :proofs, dependent: :destroy
	has_many :users, through: :proofs
	has_many :proofs, as: :proofable
end
