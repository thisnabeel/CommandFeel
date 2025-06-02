class CodeBlocksController < ApplicationController
  before_action :set_code_blockable, except: [:direct_destroy]
  before_action :set_code_block, only: [:show, :update, :destroy]

  def index
    @code_blocks = @code_blockable.code_blocks.order(position: :asc)
    render json: @code_blocks
  end

  def show
    render json: @code_block
  end

  def create
    @code_block = @code_blockable.code_blocks.build(code_block_params)
    @code_block.position = @code_blockable.code_blocks.maximum(:position).to_i + 1

    if @code_block.save!
      render json: @code_block, status: :created
    else
      render json: @code_block.errors, status: :unprocessable_entity
    end
  end

  def update
    if @code_block.update(code_block_params)
      render json: @code_block
    else
      render json: @code_block.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @code_block.destroy
    head :no_content
  end

  def reorder
    params[:code_block_ids].each_with_index do |id, index|
      CodeBlock.where(id: id, code_blockable: @code_blockable).update_all(position: index + 1)
    end
    head :ok
  end

  def direct_destroy
    @code_block = CodeBlock.find(params[:id])
    @code_block.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def set_code_blockable
    resource = request.path.split('/')[1].singularize
    klass = resource.classify.constantize
    @code_blockable = klass.find(params["#{resource}_id"])
  end

  def set_code_block
    @code_block = @code_blockable.code_blocks.find(params[:id])
  end

  def code_block_params
    params.require(:code_block).permit(:content)
  end
end 