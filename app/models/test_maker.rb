class TestMaker < ApplicationRecord
    def self.call(language, test_case)
        lines = []
        test_case["inputs"].each do |item|
            lines.push(convert(item, language))
        end
        puts "_________"
        puts language
        puts lines.join("\n")
        puts "~~~~~~~~"
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
        when "c++"
            prefix = ""
            if input[1].include? '"'
                prefix = "std::string"
            else
                prefix = "int"
            end
            return "#{prefix} #{input[0]} = #{input[1]};"
        when "c#"
            prefix = ""
            if input[1].include? '"'
                prefix = "string"
            else
                prefix = "int"
            end
            return "#{prefix} #{input[0]} = #{input[1]};"
        when "java"
            prefix = ""
            if input[1].include?('"') || input[1].include?("'")
                prefix = "string"
            else
                prefix = "int"
            end
            return "#{prefix} #{input[0]} = #{input[1]};"
        end
    end
end