class ProgrammingLanguagesController < ApplicationController
  before_action :set_programming_language, only: %i[ show update destroy traits ]

  # GET /programming_languages
  def index
    @programming_languages = ProgrammingLanguage.all.order("position ASC")

    render json: @programming_languages, each_serializer: ProgrammingLanguageSerializer, algorithms: false
  end

  def traits
    render json: @programming_language.programming_language_traits.sort_by { |pt| pt.trait.position }
  end

  def order
    list = params[:list]
    puts list
    list.each do |item|
      ProgrammingLanguage.find(item["id"].to_i).update(position: item["position"])
    end
    render json: params[:list]
  end

  # GET /programming_languages/1
  def show
    render json: @programming_language, serializer: ProgrammingLanguageSerializer, algorithms: true
  end

  # POST /programming_languages
  def create
    @programming_language = ProgrammingLanguage.new(programming_language_params)

    if @programming_language.save
      render json: @programming_language, status: :created, location: @programming_language
    else
      render json: @programming_language.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /programming_languages/1
  def update
    if @programming_language.update(programming_language_params)
      render json: @programming_language
    else
      render json: @programming_language.errors, status: :unprocessable_entity
    end
  end

  # DELETE /programming_languages/1
  def destroy
    @programming_language.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programming_language
      @programming_language = ProgrammingLanguage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def programming_language_params
      params.require(:programming_language).permit(:title, :position, :editor_slug)
    end
end
