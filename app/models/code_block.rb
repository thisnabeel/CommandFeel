class CodeBlock < ApplicationRecord
  belongs_to :code_blockable, polymorphic: true

  validates :content, presence: true
  validates :position, presence: true, numericality: { only_integer: true }
  validates :code_blockable_type, presence: true
  validates :code_blockable_id, presence: true

  # Ensure unique positions within the same code_blockable
  validates :position, uniqueness: { scope: [:code_blockable_type, :code_blockable_id] }
end 