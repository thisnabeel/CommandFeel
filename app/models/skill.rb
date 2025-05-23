class Skill < ApplicationRecord
  belongs_to :skill, optional: true

  has_many :skills, dependent: :destroy
  has_many :quests, dependent: :destroy

  has_many :abstractions, as: :abstractable, dependent: :destroy
  has_many :challenges, as: :challengeable, dependent: :destroy

  has_many :quizzes, as: :quizable
  has_many :quiz_sets, as: :quiz_setable, dependent: :destroy


  # after_create :init_position
  after_create :make_slug
  

	def settle_quizzes
		skill = self
		return if !skill.quizzes.present? 
		return if !skill.quizzes.where(quiz_set_id: nil).present?
		if !skill.quiz_sets.present?
			quiz_set = QuizSet.create(quiz_setable_type: "Skill", quiz_setable_id: skill.id, title: "Main", position: 1)
		else
			quiz_set = skill.quiz_sets.first
		end
		skill.quizzes.each_with_index do |quiz, index|
			quiz.update(quiz_set_id: quiz_set.id, position: index + 1)
		end
	end

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

	def generate_quiz(params)

		case params[:category]
		when "jeopardy"
			prompt = 'give me jeopardy question for the tech concept of "#{self.title}". return json format: {question:, answer: "#{self.title}"}'
		when "general"
			prompt = 'give me 1 question & answer that proves I understand "#{self.title}". Make sure it\'s different from the questions: #{self.quizzes.pluck(:question).join(", ")}. return json format: {question:, answer:}'
		when "general_mc"
			prompt = 'give me 1 multiple choice (4 choices) question & answer that proves I understand the engineering concept: "#{self.title}". Make sure it\'s different from the questions: #{self.quizzes.pluck(:question).join(", ")}. return json format: {question:, choices:, answer:}'
		when "techniques_mc"
			prompt = 'give me 1 multiple choice (4 choices) for: "#{self.title} technique". return json format: {question:, choices:, answer:}'
		when "abstractions_mc"
			prompt = 'multiple choice question for: #{self.title} using real life abstractions in a real-life scenario like "Imagine you are ...". return json format: {question:, choices:, answer:}'
		when "steps"
			prompt = 'Give me choices and correct answer for: "#{params[:prompt]} using #{self.title}". Question should start with "What are the steps for...", Choice should be unnumbered and unlettered. Give me json format: {question:, choices:, answer:}'
		when "scenario"
			prompt = 'Give me a scenario where #{self.title} is the answer. Pose it as "You are..." as a question without mentioning the answer at all. return json format: {question:, answer:}'
		when "scenario_mc"
			prompt = 'Give me a scenario where #{self.title} is the answer. Pose it as "You are..." as a question without mentioning the answer at all. Give me 4 choices, only one of them being the answer. return json format: {question:, choices:, answer:}'
		else
			if params[:prompt].length > 2
				prompt = 'give me 1 question regarding #{params[:prompt]}, that proves I understand #{self.title}. return json format: {question:, answer:}'
			else
				prompt = 'give me 1 question & answer that proves I understand "#{self.title}". Make sure it\'s different from the questions: #{self.quizzes.pluck(:question).join(", ")}. return json format: {question:, answer:}'
			end
		end



		res = ChatGpt.send(prompt)
		quiz = Quiz.create(
			quizable_type: "Skill",
			quizable_id: self.id,
			question: res["question"],
			quiz_set_id: params[:quiz_set_id],
		)

		if res["choices"] && res["answer"]
			res["choices"].each do |c|
				QuizChoice.create(
					quiz_id: quiz.id,
					body: c,
					correct: c === res["answer"]
				)
			end
		else
			QuizChoice.create(
				quiz_id: quiz.id,
				body: res["answer"],
				correct: true
			)
		end
		return quiz
	end

	def generate_challenge

		prompt = '
			give me a challenge I can do as one person wiht minimal tools that proves i understand #{self.title}.
			Make sure it\'s different from the questions: #{self.challenges.pluck(:title).join(", ")}.
			give me as json format: {tweet_sized_title:, instructions:}'
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
		prompt = '
			in under 280 characters, eli5 #{self.title} with simple analogy
			give it to me as a json exactly in this format {body: STRING}'
		res = ChatGpt.send(prompt)
		abstraction = Abstraction.create(
			abstractable_type: "Skill",
			abstractable_id: self.id,
			body: res["body"],
		)
		return abstraction
	end
end
