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

end
