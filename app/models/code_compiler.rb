class CodeCompiler < ApplicationRecord
    include HTTParty
    
    def self.run(options)

        puts options

        @@options = options
        @@language = ProgrammingLanguage.find(options[:programming_language_id])
        slug = @@language.editor_slug

        if ["ruby"].include? slug
            return jdoodle("ruby", 0)
        end

        if ["js", "javascript", "nodejs"].include? slug
            return jdoodle("nodejs", 1)
        end

        if ["java"].include? slug
            return jdoodle("java", 1)
        end

        if ["go"].include? slug
            return jdoodle("go", 1)
        end

        if ["c++", "cpp"].include? slug
            return jdoodle("cpp", 1)
        end

        if ["c#", "csharp"].include? slug
            return jdoodle("csharp", 1)
        end

        if ["python"].include? slug
            return jdoodle("python3", 1)
        end

        if ["swift"].include? slug
            return jdoodle("swift", 1)
        end

        if ["kotlin"].include? slug
            return jdoodle("kotlin", 3)
        end

        if ["rust"].include? slug
            return jdoodle("rust", 1)
        end

        if ["octave"].include? slug
            return jdoodle("octave", 1)
        end

    end



    def self.jdoodle(language, versionIndex)


        puts "Running #{language} Code"

        data = {
            script: @@options[:code],
            language: language,
            versionIndex: versionIndex,
            clientId: "269b93cf4a1fb308d1806fff7e4fe237",
            clientSecret:"eb73697caf871cd2b816fdb15a82acea2a7c473dfadea246c3f7d2c30b7af63c",
            compileOnly: false
        };

        res = HTTParty.post("https://api.jdoodle.com/v1/execute", 
            body: JSON.generate(data), 
            headers: {
                    'content-type': 'application/json',
                }
            )
            puts res
            puts res["output"]

            user_id = @@options[:user_id]
            if @@options[:algorithm_id]
                algorithm_id =  @@options[:algorithm_id]
                @@algorithm = Algorithm.find(algorithm_id)
                
                passing = check_passing(res["output"])
                
                if user_id.present?
                    res["passing"] = Attempt.create!(
                        user_id: user_id,
                        programming_language_id: @@language.id,
                        algorithm_id: algorithm_id,
                        passing: passing,
                        console_output: res["output"]
                    )
                else
                    puts "EXPECTATION:"
                    puts @@options[:expectation]
                    puts "RESULT:"
                    puts res["output"].gsub("\n", ' ').strip
                    res["passing"] = {
                        # user_id: user_id,
                        programming_language_id: @@language.id,
                        algorithm_id: algorithm_id,
                        passing: passing,
                        console_output: res["output"],
                        expected: @@options[:expectation]
                    }
                end
            end

            return res
    end

    def self.check_passing(output)

        if @@options[:data_type].present?
                case @@options[:data_type]
                when "array"
                    output_string = output.gsub("\n", ' ').strip
                    if output_string.starts_with? "["
                        output_array = output_string.scan(/['"](.*?)['"]/).flatten
                    else
                        output_array =  output_string.split(/\s+/)
                    end
                    
                    expectation_string = @@options[:expectation].strip
                    expectation_array = expectation_string.scan(/['"](.*?)['"]/).flatten

                    result = output_array.sort == expectation_array.sort

                    return result
                when "string"
                    return @@options[:expectation] === output.gsub("\n", ' ').strip
                when "integer"
                    return @@options[:expectation].to_i === output.gsub("\n", ' ').strip.to_i
                else
                    return
                end

        end
        
        return @@options[:expectation] === output.gsub("\n", ' ').strip
    end
end


