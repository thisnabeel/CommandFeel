class Chapter < ApplicationRecord
  belongs_to :chapter, optional: true
  has_many :chapters
end
