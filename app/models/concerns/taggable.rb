module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :tags, through: :taggings
  end

  def tag_list
    tags.pluck(:title)
  end

  def tag_list=(titles)
    self.tags = titles.map do |title|
      Tag.find_or_create_by!(title: title.strip)
    end
  end
end 