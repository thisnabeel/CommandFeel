class Challenge < ApplicationRecord
    belongs_to :challengeable, polymorphic: true
	# has_many :proofs, dependent: :destroy
	has_many :users, through: :proofs
	has_many :proofs, as: :proofable
	has_many :resume_points, -> { order(position: :asc) }, dependent: :destroy
end
