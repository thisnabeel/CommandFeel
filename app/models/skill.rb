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
	
	# Recursive method to retrieve all children in a flat array
	def all_children_with_quizzes
		children = [self] + self.skills.includes(:quizzes).to_a
		self.skills.each do |child_skill|
			children.concat(child_skill.all_children_with_quizzes)
		end
		children
	end

	# Method to get all quizzes in a flattened array
	def all_quizzes
		return self.all_children_with_quizzes.flat_map(&:quizzes).uniq.shuffle
	end

	def generate_quiz

		prompt = "
			give me 1 question & answer that proves I understand '#{self.title}'.
			Make sure it's different from the questions: #{self.quizzes.pluck(:question).join(", ") }.
return json format: {question:, answer:}"
		res = ChatGpt.send(prompt)
		quiz = Quiz.create(
			quizable_type: "Skill",
			quizable_id: self.id,
			question: res["question"]
		)

		choice = QuizChoice.create(
			quiz_id: quiz.id,
			body: res["answer"],
			correct: true
		)
		return quiz
	end

	def generate_challenge

		prompt = "
			give me a challenge I can do as one person wiht minimal tools that proves i understand #{self.title}.
			Make sure it's different from the questions: #{self.challenges.pluck(:title).join(", ") }.
give me as json format: {tweet_sized_title:, instructions:}"
		res = ChatGpt.send(prompt)
		challenge = Challenge.create(
			challengeable_type: "Skill",
			challengeable_id: self.id,
			title: res["tweet_sized_title"],
			body: res["instructions"],
		)
		return challenge
	end

	def generate_abstraction
		prompt = "
			in under 280 characters, eli5 #{self.title} with simple analogy
			give it to me as a json exactly in this format {body: STRING}"
		res = ChatGpt.send(prompt)
		abstraction = Abstraction.create(
			abstractable_type: "Skill",
			abstractable_id: self.id,
			body: res["body"],
		)
		return abstraction
	end
end
