class Quiz < ApplicationRecord
  belongs_to :quizable, polymorphic: true
  belongs_to :quiz_set
  has_many :quiz_choices, dependent: :destroy

  def self.batch_test(list)
    skills = Skill.find(list.map {|l| l["id"]})
    quizzes = []
    skills.each {|s| quizzes = quizzes + s.all_quizzes}
    return quizzes.shuffle.first(5)
  end

  def generate_choices(style)
    self.quiz_choices.all.destroy_all
    choices = []

    if style === "multiple"
      prompt = "give me 4 choices (unnumbered & unlettered & unordered) for the question: #{self.question}. Only one of the choices should be correct, and the others should be believable but wrong. the :answer should be the correct :choice. return json format: {question:, choices:, answer:}"
    else
      prompt = self.question + ". return json format: {question:, answer:}"
    end
    
    res = ChatGpt.send(prompt)

		if res["choices"] && res["answer"]
			res["choices"].each do |c|
				c = QuizChoice.create(
					quiz_id: self.id,
					body: c,
					correct: c === res["answer"]
				)
        choices.push(c)
			end
		else
			c = QuizChoice.create(
				quiz_id: self.id,
				body: res["answer"],
				correct: true
			)
      choices.push(c)
		end

    return choices
  end

end
