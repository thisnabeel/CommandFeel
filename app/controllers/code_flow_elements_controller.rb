class CodeFlowElementsController < ApplicationController
  before_action :set_code_flow_element, only: %i[ show update destroy ]

  # GET /code_flow_elements
  # GET /code_flow_elements
  def index
    if params[:query].present?
      q = params[:query].downcase
      @code_flow_elements = CodeFlowElement.where("LOWER(title) LIKE ?", "%#{q}%")
    else
      @code_flow_elements = CodeFlowElement.all
    end

    render json: @code_flow_elements
  end

  # GET /code_flow_elements/1
  def show
    render json: @code_flow_element
  end

  # POST /code_flow_elements
  def create
    @code_flow_element = CodeFlowElement.new(code_flow_element_params)

    if @code_flow_element.save
      render json: @code_flow_element, status: :created, location: @code_flow_element
    else
      render json: @code_flow_element.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /code_flow_elements/1
  def update
    if @code_flow_element.update(code_flow_element_params)
      render json: @code_flow_element
    else
      render json: @code_flow_element.errors, status: :unprocessable_entity
    end
  end

  # DELETE /code_flow_elements/1
  def destroy
    @code_flow_element.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_code_flow_element
      @code_flow_element = CodeFlowElement.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def code_flow_element_params
      params.require(:code_flow_element).permit(:title, :category)
    end
end
