class Abstraction < ApplicationRecord
  belongs_to :abstractable, polymorphic: true

  validates :level, inclusion: { in: 0..2 }

  before_validation :normalize_level

  private

  def normalize_level
    self.level = 0 if level.nil?
  end
end
