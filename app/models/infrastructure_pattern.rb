class InfrastructurePattern < ApplicationRecord
  has_many :wonder_infrastructure_patterns, dependent: :destroy
  has_many :wonders, through: :wonder_infrastructure_patterns
  
  has_many :infrastructure_pattern_dependencies, dependent: :destroy
  has_many :skills, through: :infrastructure_pattern_dependencies, source: :dependable, source_type: 'Skill'
  has_many :wonder_dependencies, through: :infrastructure_pattern_dependencies, source: :dependable, source_type: 'Wonder'

  validates :title, presence: true

  def self.generate_patterns
    prompt = <<~PROMPT
      Create a list of 20 backend infrastructure responsibilities and architectural patterns commonly used in building real-time applications like chat, notifications, message boards, and feed systems. Each item should:

      - make sure it's not included in the list of patterns below: **#{InfrastructurePattern.pluck(:title, :description).join(', ')}**
      - Be 2–6 words long (e.g., "message persistence", "multi-instance coordination")
      - Reflect a specific system behavior or design responsibility (not technologies)
      - Be followed by a one-sentence explanation of its role in a scalable system

      Avoid naming specific tools (like Kafka or Redis), but focus on *what* the system needs to do under the hood.

      Return strictly valid JSON in this format:
      ```json
      [
        {
          "title": "2-6 word pattern name",
          "description": "One sentence explanation"
        }
      ]
      ```

      Do NOT include any explanation outside the JSON block.
    PROMPT

    response = ChatGpt.send(prompt)
    
    # Parse the JSON from the content field
    json_content = response["answer"].match(/```json\n(.*?)\n```/m)[1]
    patterns_data = JSON.parse(json_content)
    
    # Create infrastructure patterns from the response
    created_patterns = []
    
    ActiveRecord::Base.transaction do
      patterns_data.each_with_index do |pattern_data, index|
        pattern = InfrastructurePattern.create!(
          title: pattern_data["title"],
          description: pattern_data["description"],
          position: index + 1,
          visibility: true
        )
        created_patterns << pattern
      end
    end

    created_patterns
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse ChatGPT response: #{e.message}")
    raise
  rescue StandardError => e
    Rails.logger.error("Error generating infrastructure patterns: #{e.message}")
    raise
  end
end 