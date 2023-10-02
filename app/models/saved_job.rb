class SavedJob < ApplicationRecord
    belongs_to :user

    def find_skills
        keywords = Skill.all.pluck(:title).map{|title| title.downcase}
        text = self.jd
        keywords_present = keywords.select { |keyword| text.match?(/\b#{Regexp.escape(keyword)}\b/i) }

        skills_found = keywords_present.map do |keyword|
            Skill.find_by("lower(title) = ?", keyword.downcase)
        end.compact
        # puts "Keywords present in the text: #{keywords_present}"
        return skills_found
    end
end
