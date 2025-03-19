class ResumesController < ApplicationController
    def prompt
        jd = params[:jd]

        prompt = "#{jd} ---- give me a list of action oriented resume bullet points in past tense for applying for this job description. return json format: {points: []}"
        # prompt = "give me impressive metric-based resume bullet points for DevSecOps as if ive worked for a large enterprise company. return json format: {points: []}"
        res = ChatGpt.send(prompt)
        render json: res
    end


end