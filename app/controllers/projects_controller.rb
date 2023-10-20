class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show update destroy ]

  # GET /projects
  def index
    @projects = Project.all

    render json: @projects
  end

  def by_user
    projects = User.find(params[:user_id]).projects.order("updated_at ASC")
    render json: projects
  end

  # GET /projects/1
  def show
    render json: @project
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project, status: :created, location: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def create
    @project = Project.new(project_params)

    
    if @project.save!

      @proof = Proof.create!(
        proofable_type: "Project", 
        proofable_id: @project.id,
        title: nil,
        user_id: params[:user_id]
      )

      ProofLink.create!(
        url: params[:proof_link][:url], 
        proof_id: @proof.id, 
        user_id: params[:user_id]
      )

      render json: @proof, serializer: ProofSerializer, status: :created, location: @proof
    else
      render json: @proof.errors, status: :unprocessable_entity
    end
  end
  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:user_id, :title, :description, :position)
    end
end
