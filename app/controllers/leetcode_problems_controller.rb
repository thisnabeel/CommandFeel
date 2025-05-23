class LeetcodeProblemsController < ApplicationController
  before_action :set_leetcode_problem, only: %i[ show update destroy ]

  # GET /leetcode_problems
  def index
    @leetcode_problems = LeetcodeProblem.all

    render json: @leetcode_problems
  end

  # GET /leetcode_problems/1
  def show
    render json: @leetcode_problem
  end

  # POST /leetcode_problems
  def create
    @leetcode_problem = LeetcodeProblem.new(leetcode_problem_params)

    if @leetcode_problem.save
      render json: @leetcode_problem, status: :created, location: @leetcode_problem
    else
      render json: @leetcode_problem.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /leetcode_problems/1
  def update
    if @leetcode_problem.update(leetcode_problem_params)
      render json: @leetcode_problem
    else
      render json: @leetcode_problem.errors, status: :unprocessable_entity
    end
  end

  # DELETE /leetcode_problems/1
  def destroy
    @leetcode_problem.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leetcode_problem
      @leetcode_problem = LeetcodeProblem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def leetcode_problem_params
      params.require(:leetcode_problem).permit(:title, :description, :difficulty, :url, :topics)
    end
end
