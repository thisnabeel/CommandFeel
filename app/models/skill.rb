class Skill < ApplicationRecord
  belongs_to :skill, optional: true

  has_many :skills, dependent: :destroy

  has_many :abstractions, as: :abstractable, dependent: :destroy
  has_many :challenges, as: :challengeable, dependent: :destroy

  has_many :quizzes, as: :quizable, dependent: :destroy

  # after_create :init_position
  after_create :make_slug
  
	# Find all skills and check if they have slug
	def self.make_slugs
		Skill.where(slug: nil).each do |s|
			s.make_slug
		end
	end

	def make_slug
		title = self.title.parameterize
		while !self.update(slug: title)
			title = "#{self.title.parameterize}-#{self.id}"
		end
  end
end
