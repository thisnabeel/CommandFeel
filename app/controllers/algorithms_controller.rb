class AlgorithmsController < ApplicationController
  before_action :set_algorithm, only: %i[ show update destroy ]

  # GET /algorithms
  def index
    @algorithms = Algorithm.all.order("position ASC")

    render json: @algorithms
  end

  # GET /algorithms/1
  def show
    render json: @algorithm
  end

  def execute_code
    render json: CodeCompiler.run(params)
  end
  
  # POST /algorithms
  def create
    @algorithm = Algorithm.new(algorithm_params)

    if @algorithm.save
      render json: @algorithm, status: :created, location: @algorithm
    else
      render json: @algorithm.errors, status: :unprocessable_entity
    end
  end


  def order
    list = params[:list]
    puts list
    list.each do |item|
      Algorithm.find(item["id"]).update(position: item["position"])
    end
    render json: params[:list]
  end

  # PATCH/PUT /algorithms/1
  def update
    if @algorithm.update(algorithm_params)
      render json: @algorithm
    else
      render json: @algorithm.errors, status: :unprocessable_entity
    end
  end

  # DELETE /algorithms/1
  def destroy
    @algorithm.destroy
  end

  def execute
    lang = params[:language][:title].downcase
    test_case = params[:test_case]
    made = TestMaker.call(lang, test_case)
    code = params[:code].gsub("~~", made)
    puts code
    render json: CodeCompiler.run({
            code: code,
            algorithm_id: params[:algorithm_id],
            programming_language_id: params[:language][:id],
            user_save: false,
            expectation: test_case[:expectation]
        })
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_algorithm
      @algorithm = Algorithm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def algorithm_params
      params.require(:algorithm).permit!
    end
end
