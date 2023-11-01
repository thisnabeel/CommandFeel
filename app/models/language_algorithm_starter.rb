class LanguageAlgorithmStarter < ApplicationRecord
    belongs_to :algorithm
    belongs_to :programming_language
    has_many :test_cases
    # serialize :code_lines, JSON
end
