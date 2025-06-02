class TagsController < ApplicationController
  before_action :set_taggable, only: [:index, :create, :destroy]
  before_action :set_tag, only: [:show, :update, :destroy, :taggables]

  # GET /tags/search?q=search_term
  def search
    query = params[:q].to_s.strip
    
    if query.present?
      @tags = Tag.where("LOWER(title) LIKE ?", "%#{query.downcase}%")
    else
      @tags = Tag.none
    end

    render json: @tags
  end

  # GET /tags
  # GET /skills/:skill_id/tags
  # GET /wonders/:wonder_id/tags
  def index
    @tags = if @taggable
              @taggable.tags
            else
              Tag.all
            end
    
    render json: @tags
  end

  # GET /tags/:id
  def show
    render json: @tag
  end

  # POST /tags
  def create
    if @taggable
      # Create and associate tag with taggable
      if create_params[:title].present?
        @tag = Tag.find_or_create_by!(title: create_params[:title])
      elsif create_params[:tag_id].present?
        @tag = Tag.find(create_params[:tag_id])
      else
        render json: { error: "Must provide either title or tag_id" }, status: :unprocessable_entity
        return
      end

      @taggable.tags << @tag unless @taggable.tags.include?(@tag)
      render json: @tag, status: :created
    else
      # Direct tag creation
      @tag = Tag.new(tag_params)
      if @tag.save
        render json: @tag, status: :created
      else
        render json: @tag.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /tags/:id
  def update
    if @tag.update(tag_params)
      render json: @tag
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/:id
  # DELETE /skills/:skill_id/tags/:id
  # DELETE /wonders/:wonder_id/tags/:id
  def destroy
    if @taggable
      # Remove tag from taggable
      @taggable.tags.delete(@tag)
      head :no_content
    else
      # Delete tag entirely
      @tag.destroy
      head :no_content
    end
  end

  # GET /tags/:id/taggables
  def taggables
    items = {
      skills: @tag.skills.select(:id, :title, :description).map { |s| 
        { id: s.id, title: s.title, description: s.description, type: 'Skill' }
      },
      wonders: @tag.wonders.select(:id, :title, :description).map { |w| 
        { id: w.id, title: w.title, description: w.description, type: 'Wonder' }
      },
      code_comparisons: @tag.code_comparisons.select(:id, :title).map { |c| 
        { id: c.id, title: c.title, type: 'CodeComparison' }
      }
    }

    # Flatten all items into a single array
    flattened_items = items.values.flatten

    render json: {
      tag: { id: @tag.id, title: @tag.title },
      items: flattened_items
    }
  end

  private

  def set_taggable
    if params[:skill_id]
      @taggable = Skill.find(params[:skill_id])
    elsif params[:wonder_id]
      @taggable = Wonder.find(params[:wonder_id])
    elsif params[:code_comparison_id]
      @taggable = CodeComparison.find(params[:code_comparison_id])
    end
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def create_params
    # Handle both wrapped and unwrapped parameters
    if params[:tag].present?
      params.require(:tag).permit(:title, :tag_id)
    else
      params.permit(:title, :tag_id)
    end
  end

  def tag_params
    params.require(:tag).permit(:title)
  end
end 