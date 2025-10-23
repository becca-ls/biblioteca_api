class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :update, :destroy]

  # GET /materials
  def index
    materials = policy_scope(Material).order(created_at: :desc)
    render json: materials
  end

  # GET /materials/:id
  def show
    authorize @material
    render json: @material
  end

  # POST /materials
  def create
    @material = current_user.materials.build(material_params)
    authorize @material

    if @material.save
      render json: @material, status: :created
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /materials/:id
  def update
    authorize @material
    if @material.update(material_params)
      render json: @material
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /materials/:id
  def destroy
    authorize @material
    @material.destroy
    head :no_content
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(
      :type, :title, :description, :published_at, :isbn, :url, :archived
    )
  end
end
