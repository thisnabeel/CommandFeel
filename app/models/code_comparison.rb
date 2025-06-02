class CodeComparison < ApplicationRecord
  include Taggable
  
  belongs_to :answerable, polymorphic: true, optional: true
  
  has_many :code_blocks, -> { order(position: :asc) }, 
           as: :code_blockable,
           dependent: :destroy

  validates :title, presence: true
end 