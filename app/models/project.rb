class Project < ApplicationRecord
    belongs_to :user
	has_one :proof, as: :proofable
    has_many :project_skills
end
