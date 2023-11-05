class TestMaker < ApplicationRecord
    def self.call(language, test_case)
        lines = []
        test_case["inputs"].each do |item|
            lines.push(convert(item, language))
        end
        return lines.join("\n")
        # take an algortihm
        # each algo test case
        # -- each input
        # ---- convert_input(language)
        # ---- join by "\n"
        # return tests
    end

    def self.convert(input, language)
        case language.downcase
        when "ruby"
            return "#{input[0]} = #{input[1]}"
        when "python"
            return "#{input[0]} = #{input[1]}"
        when "javascript"
            return "let #{input[0]} = #{input[1]}"
        else
        end
    end
end