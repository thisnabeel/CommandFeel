class FeatureFlag < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.enabled?(key)
    find_by(key: key.to_s)&.enabled == true
  end

  def self.as_map
    pluck(:key, :enabled).to_h
  end
end
