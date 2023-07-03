class CodeCompiler < ApplicationRecord
    include HTTParty
    
    def self.run(language, code)

        @@language = language
        @@code = code

        if ["ruby"].include? language
            return jdoodle(language, 0)
        end


        if ["js", "javascript", "nodejs"].include? language
            return jdoodle("nodejs", 1)
        end

        if ["java"].include? language
            return jdoodle("java", 1)
        end

        if ["go"].include? language
            return jdoodle("go", 1)
        end

        if ["c++", "cpp"].include? language
            return jdoodle("cpp", 1)
        end

        if ["c#", "csharp"].include? language
            return jdoodle("csharp", 1)
        end

        if ["python"].include? language
            return jdoodle("python3", 1)
        end

        if ["swift"].include? language
            return jdoodle("swift", 1)
        end

        if ["kotlin"].include? language
            return jdoodle("kotlin", 1)
        end

        if ["rust"].include? language
            return jdoodle("rust", 1)
        end

    end



    def self.jdoodle(language, versionIndex)


        puts "Running #{language} Code"

        data = {
            script: @@code,
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
            return res
    end
end


