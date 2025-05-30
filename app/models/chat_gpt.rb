class ChatGpt < ActiveRecord::Base
    def self.send(prompt)
        
        client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
        puts client
        puts client.as_json

        puts "The prompt: #{prompt}"
        content = "#{prompt}"

        # Construct a new conversation with only the user message
        messages = [{ role: "user", content: content }]

        response = client.chat(
        parameters: {
            model: "gpt-4o",
            messages: messages,
            temperature: 0.7,
        }
        )

        # return response.dig("choices", 0, "message", "content")

        begin
            jsonResponse = JSON.parse(response.dig("choices", 0, "message", "content").lstrip)
        rescue
            jsonResponse = { "answer" => response.dig("choices", 0, "message", "content").lstrip }
        end

        return jsonResponse

    end
end
