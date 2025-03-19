class ProgrammingLanguage < ApplicationRecord
    has_many :programming_language_traits
    has_many :language_algorithm_starters

    has_many :challenges, as: :challengeable, dependent: :destroy
end
