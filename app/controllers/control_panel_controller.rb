class ControlPanelController < ApplicationController
    def empty_abstractions
        skills = Skill.includes(:abstractions).where(abstractions: { id: nil })
        render json: skills, each_serializer: SkillSerializer
    end

    def empty_quizzes
        quizzes = Quiz.joins(:quiz_choices).where(quiz_choices: { body: 'untitled' })
        render json: quizzes
    end
end