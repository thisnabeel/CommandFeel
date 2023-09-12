class LanguageAlgorithmStarter < ApplicationRecord
    belongs_to :algorithm
    belongs_to :programming_language
    # serialize :code_lines, JSON
end
