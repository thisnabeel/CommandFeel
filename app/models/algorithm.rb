class Algorithm < ApplicationRecord

    has_many :language_algorithm_starters
    has_many :algorithms
    belongs_to :algorithm, optional: true
    # has_many :test_cases
    # serialize :input_params
    # serialize :test_cases

    def expected_with_type
        x = self.expected
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
