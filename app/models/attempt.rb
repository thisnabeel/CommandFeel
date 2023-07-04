class Attempt < ApplicationRecord
    belongs_to :user
    belongs_to :programming_language
    belongs_to :algorithm
end
