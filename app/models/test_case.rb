class TestCase < ApplicationRecord
    belongs_to :language_algorithm_starter

    def execute_code(code)

        # puts code
        starter = self.language_algorithm_starter

        testing_code = code
        # testing_code = starter.code_lines.map {|l| 
        #     if l["prefix_test"] === true
        #         [self.code, l["code"]].join("\n")
        #     else
        #         l["code"]
        #     end
        # }.join("\n")

        puts "TESTING CODE"
        puts testing_code

        return CodeCompiler.run({
            code: testing_code,
            algorithm_id: starter.algorithm_id,
            programming_language_id: starter.programming_language_id,
            user_save: false,
            expectation: self.expected_with_type
        })
    end

    def expected_with_type
        x = self.expectation
        if !x.present? || x === ""
            return nil
        end

        if x.starts_with? "STRING"
            return x.split("STRING ")[1]
        end

        if x.starts_with? "INT"
            return x.split("INT ")[1]
        end

        if x.starts_with? "BOOLEAN"
            return x.split("BOOLEAN ")[1]
        end

        return nil
    end
end
