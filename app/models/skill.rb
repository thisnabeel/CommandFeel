class Skill < ApplicationRecord
  include Taggable

  belongs_to :skill, optional: true

  has_many :skills, dependent: :destroy
  has_many :quests, as: :questable, dependent: :destroy
  has_many :code_comparisons, as: :answerable, dependent: :nullify

  has_many :abstractions, as: :abstractable, dependent: :destroy
  has_many :challenges, as: :challengeable, dependent: :destroy
  has_many :skill_histories, dependent: :destroy

  has_many :quizzes, as: :quizable
  has_many :quiz_sets, as: :quiz_setable, dependent: :destroy

  has_many :infrastructure_pattern_dependencies, as: :dependable, dependent: :destroy
  has_many :dependent_infrastructure_patterns, through: :infrastructure_pattern_dependencies, source: :infrastructure_pattern

  has_many :scripts, as: :scriptable, dependent: :destroy

  has_many :project_requirement_tools, as: :toolable

  has_many :phrase_links, as: :phrasable, dependent: :destroy
  has_many :phrases, through: :phrase_links

  has_many :occupation_skills, dependent: :destroy
  has_many :occupations, through: :occupation_skills

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
		when "use_case"
			prompt = "For #{self.title} Give me 4 realistic options each of some relevant usage of it and some not, and user has to choose which ones are relavant use cases (multiple can be correct). trains them to think of tool. return json format: {question:, choices:, answer:}"
		else
			if params[:prompt].length > 2
				prompt = 'give me 1 question regarding #{params[:prompt]}, that proves I understand #{self.title}. return json format: {question:, answer:}'
			else
				prompt = 'give me 1 question & answer that proves I understand "#{self.title}". Make sure it\'s different from the questions: #{self.quizzes.pluck(:question).join(", ")}. return json format: {question:, answer:}'
			end
		end

		response = ChatGpt.send(prompt)
		
		# Parse the JSON from the content field - it's in the answer field and between ```json markers
		json_content = response["answer"].match(/```json\n(.*?)\n```/m)[1]
		data = JSON.parse(json_content)
		
		quiz = Quiz.create!(
			quizable_type: "Skill",
			quizable_id: self.id,
			question: data["question"],
			quiz_set_id: params[:quiz_set_id],
		)

		if data["choices"].present?
			if data["answer"].is_a?(Array)
				# Handle multiple correct answers (like in use_case)
				data["choices"].each do |choice|
					# Remove any numbering from the choice if present
					clean_choice = choice.sub(/^\d+\.\s*/, '')
					QuizChoice.create!(
						quiz_id: quiz.id,
						body: clean_choice,
						correct: data["answer"].any? { |answer| answer.include?(clean_choice) }
					)
				end
			else
				# Handle single correct answer
				data["choices"].each do |choice|
					QuizChoice.create!(
						quiz_id: quiz.id,
						body: choice,
						correct: choice == data["answer"]
					)
				end
			end
		else
			QuizChoice.create!(
				quiz_id: quiz.id,
				body: data["answer"],
				correct: true
			)
		end
		
		return quiz
	rescue JSON::ParserError => e
		Rails.logger.error("Failed to parse ChatGPT response: #{e.message}")
		raise
	rescue StandardError => e
		Rails.logger.error("Error generating quiz: #{e.message}")
		raise
	end

	def generate_challenge

		prompt = "
			give me a challenge I can do as one person wiht minimal tools that proves i understand #{self.title}.
			Make sure it\'s different from the questions: #{self.challenges.pluck(:title).join(", ")}.
			give me as json format: {tweet_sized_title:, instructions: Text(HTML ol list)}"
		res = WizardService.ask(prompt)
		puts "res: #{res}"
		challenge = Challenge.create(
			challengeable_type: "Skill",
			challengeable_id: self.id,
			title: res["tweet_sized_title"],
			body: res["instructions"],
		)
		return challenge
	end

	# Nested path of parent skills for disambiguation (e.g. "Testing > Smoke Testing")
	def breadcrumb
		titles = []
		node = self
		seen = {}
		while node
			break if seen[node.id]
			seen[node.id] = true
			titles.unshift(node.title)
			node = node.skill
		end
		titles.join(' > ')
	end

	def generate_history
		prompt = <<~PROMPT
			You are writing a short blog-post style history of a software engineering / computer science concept.

			Concept path (nested breadcrumb — use this full path so you do NOT confuse this concept with another skill that shares the same leaf name under a different parent):
			#{breadcrumb}

			Leaf concept: #{title}

			INSTRUCTIONS:
			- Explain the origin and evolution of THIS concept in its nested context
			- Use the breadcrumb path for disambiguation and accuracy
			- Suitable for learners; avoid fluff
			- Structure like a mini blog post with clear hierarchy
			- Return RICH HTML only inside the JSON body string (not markdown)
			- Use semantic tags: <h2>, <h3>, <p>, <ul><li>, <strong>, <em>, <blockquote> as appropriate
			- Start with an <h2> title for the piece
			- Include 2–4 short sections (origin, how it evolved, why it matters today)
			- Do NOT wrap the HTML in <html>, <body>, or markdown code fences
			- Keep total length roughly 500–900 words of visible text maximum; prefer ~400–700 words

			OUTPUT:
			Strictly return valid JSON, formatted like this:

			```json
			{
				"body": "<h2>Title</h2><p>Opening paragraph...</p><h3>Origins</h3><p>...</p>"
			}
			```

			Do NOT include any explanation outside the JSON block.
		PROMPT

		response = ChatGpt.send(prompt)
		json_content = response['answer'].match(/```json\n(.*?)\n```/m)[1]
		history_data = JSON.parse(json_content)
		body = history_data['body'].to_s
		# If the model returns escaped plaintext HTML entities, leave as-is; TipTap accepts HTML tags.
		body = "<p>#{body}</p>" if body.present? && !body.include?('<')

		SkillHistory.create!(
			skill_id: id,
			body: body
		)
	rescue JSON::ParserError => e
		Rails.logger.error("Failed to parse ChatGPT response: #{e.message}")
		raise
	rescue StandardError => e
		Rails.logger.error("Error generating skill history: #{e.message}")
		raise
	end

	def generate_abstraction(level = 0)
		level = level.to_i
		level = 0 unless (0..2).include?(level)

		prompt = abstraction_prompt_for_level(level)

		response = ChatGpt.send(prompt)

		# Parse the JSON from the content field - it's in the answer field and between ```json markers
		json_content = response["answer"].match(/```json\n(.*?)\n```/m)[1]
		abstraction_data = JSON.parse(json_content)

		abstraction = Abstraction.create!(
			abstractable_type: "Skill",
			abstractable_id: self.id,
			body: abstraction_data["body"],
			level: level
		)

		return abstraction
	rescue JSON::ParserError => e
		Rails.logger.error("Failed to parse ChatGPT response: #{e.message}")
		raise
	rescue StandardError => e
		Rails.logger.error("Error generating abstraction: #{e.message}")
		raise
	end

	private

	def abstraction_prompt_for_level(level)
		instructions = case level
		when 1
			<<~INSTRUCTIONS.strip
				- Stay in the domain of tech (computers, software, apps, the web) — do not use non-tech real-world analogies
				- Explain for someone new to tech using approachable tech concepts
				- Basic computer terms are OK (files, folders, apps, clicking, browsers)
				- Keep it concrete and under 280 characters
				- Avoid deep developer jargon
			INSTRUCTIONS
		when 2
			<<~INSTRUCTIONS.strip
				- Explain the concept for a developer or adjacent technical reader
				- Precise technical jargon is OK
				- Be accurate and direct; prefer clarity over analogy
				- Keep the explanation under 280 characters
			INSTRUCTIONS
		else
			<<~INSTRUCTIONS.strip
				- Create a simple, real-world analogy that explains the concept
				- Use everyday examples that anyone can understand
				- Keep the explanation under 280 characters
				- Make it ELI5 (Explain Like I'm 5) friendly
				- Avoid technical jargon
			INSTRUCTIONS
		end

		<<~PROMPT
			You are generating an analogy/abstraction for a computer science concept.

			Concept: #{self.title}

			INSTRUCTIONS:
			#{instructions}

			OUTPUT:
			Strictly return valid JSON, formatted like this:

			```json
			{
				"body": "Your simple analogy here"
			}
			```

			Do NOT include any explanation outside the JSON block.
		PROMPT
	end
end
