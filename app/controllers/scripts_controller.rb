class ScriptsController < ApplicationController
  before_action :set_scriptable, only: [:index, :create]
  before_action :set_script, only: [:show, :update, :destroy]

  def index
    @scripts = if @scriptable
                 @scriptable.scripts.order(position: :asc)
               else
                 Script.all.order(position: :asc)
               end
    render json: @scripts
  end

  def show
    render json: @script
  end

  def create
    @script = @scriptable.scripts.build(script_params)
    if @script.save
      render json: @script, status: :created
    else
      render json: @script.errors, status: :unprocessable_entity
    end
  end

  def update
    if @script.update(script_params)
      render json: @script
    else
      render json: @script.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @script.destroy
    head :no_content
  end

  def reorder
    params[:script_ids].each_with_index do |id, index|
      Script.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def script_wizard
    begin
      abstraction = Abstraction.find(params[:abstraction_id])
      scriptable = abstraction.abstractable
      
      puts "Found abstraction: #{abstraction.inspect}"
      puts "Found scriptable: #{scriptable.inspect}"

      prompt = <<~PROMPT
        You are generating a 60-120 second script for a Software Engineering technical concept.

        Technical Concept: #{scriptable.title}
        Real-world Analogy: #{abstraction.body}

        INSTRUCTIONS:
        - Create a 60-120 second script that explains the concept
        - Start with a hook question "What do [key items from the analogy] have to do with [the technical struggle]?"
        - Follow with "As a [Relevant Tech Profession] Have you ever struggled with..." where you choose an appropriate tech role that would commonly deal with this concept (e.g. Backend Developer, DevOps Engineer, Frontend Developer, System Architect, Database Administrator, etc.)
        - Then introduce the technical concept title
        - If possible and engaging enough, include a history lesson for why the concept is called that and what caused it to be discovered/created.
        - Bridge to the real-world analogy to make it relatable
        - Keep it concise, engaging, and conversational
        - Each sentence should be impactful and clear
        - Aim for clarity and memorability
        - End with a strong takeaway
        - Generate a catchy, memorable title that reflects the main theme or hook of your script
        - The title should be creative and engaging, not just the concept name

        Additionally, create platform-specific versions:
        1. LinkedIn Post (max 300 characters):
        - Professional tone
        - Focus on the business/career value
        - Include the challenge and solution
        - End with a clear takeaway

        2. TikTok Script (max 150 characters):
        - Casual, engaging tone
        - Hook in the first line
        - Focus on the "aha moment"
        - Use relatable language

        3. YouTube:
        - Catchy title (max 60 characters)
        - Engaging description that expands on the main script
        - Include key points and timestamps
        - SEO-friendly description

        OUTPUT:
        Strictly return valid JSON, formatted like this:

        ```json
        {
          "title": "From Chaos to Clarity: How RESTful APIs Bring Order to Web Services",
          "body": "What do library card catalogs have to do with messy web services? As a Backend Developer, have you ever struggled with integrating different web services, feeling lost in a maze of inconsistent endpoints and unpredictable data formats? This is where RESTful APIs come to the rescue. The term REST was coined by Roy Fielding in his 2000 doctoral dissertation, where he outlined these principles to make web services more standardized and scalable. Think of a library's card catalog system. Just as you use it to locate books efficiently without searching every shelf, RESTful APIs serve as an organized system for accessing digital resources. In a traditional library, each card contains essential information. Similarly, RESTful APIs provide standardized 'endpoints' that tell you exactly how to request specific information. When you want a book, you follow the library's established process. RESTful APIs work the same way with predictable request and response patterns. Just as library systems worldwide use similar organization methods, REST provides a universal language for web services. This standardization is why RESTful APIs have become the backbone of modern web development. Remember: If you can navigate a library's card catalog, you already understand the fundamental principle of RESTful APIs.",
          "linkedin_body": "🔍 Backend developers: Tired of wrestling with inconsistent APIs? RESTful APIs bring order to chaos, just like a library's card catalog system organizes books. Learn how this architectural style standardizes web services and makes integration a breeze. #WebDevelopment #APIs #SoftwareEngineering",
          "tiktok_body": "POV: You're a dev dealing with messy APIs 😫 Enter REST: Your digital library card system 📚✨ One standard to rule them all! #CodeTok #TechTok #Programming",
          "youtube_title": "REST APIs Explained: From Library Cards to Web Services 📚→💻",
          "youtube_body": "Demystifying RESTful APIs through real-world analogies! In this video, we explore how REST brings structure to web services, just like a library catalog brings order to books.\n\nTimestamps:\n0:00 The Integration Challenge\n0:30 Understanding REST\n1:00 The Library Analogy\n1:30 Real-world Application\n2:00 Key Takeaways\n\nLearn how REST:\n- Standardizes web communication\n- Makes integration easier\n- Scales your applications\n\n#WebDevelopment #APIs #CodingTutorial #SoftwareEngineering"
        }
        ```

        Do NOT include any explanation outside the JSON block.
      PROMPT

      script_data = WizardService.ask(prompt)
      
      # Format each sentence with paragraph tags
      formatted_body = script_data["body"]
        .split(/(?<=[.!?])\s+/)  # Split on sentence endings
        .map { |sentence| "<p>#{sentence.strip}</p>" }
        .join("\n")

      script = scriptable.scripts.new(
        title: script_data["title"].strip,
        body: formatted_body,
        linkedin_body: script_data["linkedin_body"],
        tiktok_body: script_data["tiktok_body"],
        youtube_title: script_data["youtube_title"],
        youtube_body: script_data["youtube_body"],
        position: (scriptable.scripts.maximum(:position) || 0) + 1
      )

      puts "Attempting to save script with: #{script.attributes.inspect}"
      
      if script.save
        puts "Script saved successfully!"
        render json: script, status: :created
      else
        puts "Script failed to save with errors: #{script.errors.full_messages}"
        render json: { 
          error: "Failed to save script", 
          details: script.errors.full_messages,
          script_attributes: script.attributes 
        }, status: :unprocessable_entity
      end

    rescue ActiveRecord::RecordNotFound => e
      render json: { error: "Abstraction not found", details: e.message }, status: :not_found
    rescue JSON::ParserError => e
      render json: { error: "Failed to parse ChatGPT response", details: e.message }, status: :unprocessable_entity
    rescue StandardError => e
      puts "Error in script_wizard: #{e.class} - #{e.message}"
      puts e.backtrace.join("\n")
      render json: { 
        error: "An error occurred", 
        error_class: e.class.to_s,
        details: e.message,
        backtrace: e.backtrace.first(5)
      }, status: :unprocessable_entity
    end
  end

  private

  def set_scriptable
    if params[:skill_id]
      @scriptable = Skill.find(params[:skill_id])
    elsif params[:wonder_id]
      @scriptable = Wonder.find(params[:wonder_id])
    end
  end

  def set_script
    @script = params[:skill_id] || params[:wonder_id] ?
      @scriptable.scripts.find(params[:id]) :
      Script.find(params[:id])
  end

  def script_params
    params.require(:script).permit(:title, :body, :position)
  end
end 