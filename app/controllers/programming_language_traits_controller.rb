class ProgrammingLanguageTraitsController < ApplicationController
  before_action :set_programming_language_trait, only: %i[ show update destroy ]

  # GET /programming_language_traits
  def index
    @programming_language_traits = ProgrammingLanguageTrait.all

    render json: @programming_language_traits
  end

  # GET /programming_language_traits/1
  def show
    render json: @programming_language_trait
  end

  def find
    render json: ProgrammingLanguageTrait.find_by(
      trait_id: params[:trait_id], 
      programming_language_id: params[:programming_language_id]
    )
  end

  # POST /programming_language_traits
  def create
    @programming_language_trait = ProgrammingLanguageTrait.find_or_create_by(
      programming_language_id: programming_language_trait_params[:programming_language_id],
      trait_id: programming_language_trait_params[:trait_id],
    )

    @programming_language_trait.body = programming_language_trait_params[:body]

    if @programming_language_trait.save
      render json: @programming_language_trait, status: :created, location: @programming_language_trait
    else
      render json: @programming_language_trait.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /programming_language_traits/1
  def update
    if @programming_language_trait.update(programming_language_trait_params)
      render json: @programming_language_trait
    else
      render json: @programming_language_trait.errors, status: :unprocessable_entity
    end
  end

  # DELETE /programming_language_traits/1
  def destroy
    @programming_language_trait.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programming_language_trait
      @programming_language_trait = ProgrammingLanguageTrait.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def programming_language_trait_params
      params.require(:programming_language_trait).permit(:programming_language_id, :trait_id, :body)
    end
end
