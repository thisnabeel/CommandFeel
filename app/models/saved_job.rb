class SavedJob < ApplicationRecord
    belongs_to :user

    def find_skills
        keywords = Skill.all.pluck(:title).map{|title| title.downcase}
        text = self.jd
        keywords_present = keywords.select { |keyword| text.match?(/\b#{Regexp.escape(keyword)}\b/i) }

        # puts "Keywords present in the text: #{keywords_present}"
        return keywords_present
    end
end
