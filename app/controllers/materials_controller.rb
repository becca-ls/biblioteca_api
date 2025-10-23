class MaterialsController < ApplicationController
  before_action :set_material, only: %i[show update destroy]
  def index
    materials = policy_scope(Material).order(created_at: :desc)
    render json: materials
  end
  def show
    authorize @material
    render json: @material
  end
  def create
    authorize Material
    klass     = material_klass
    owner     = respond_to?(:current_user) ? current_user : nil
    @material = klass.new(material_params.merge(user: owner))

    if @material.save
      render json: @material, status: :created
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    authorize @material
    if @material.update(material_params)
      render json: @material
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def destroy
    authorize @material
    @material.destroy
    head :no_content
  end
  private
  ALLOWED_TYPES = %w[Book Article Video].freeze
  def set_material
    @material = Material.find(params[:id])
  end
  def material_klass
    type = params.dig(:material, :type)
    return Material unless ALLOWED_TYPES.include?(type)
    type.constantize
  end
  def material_params
    params.require(:material).permit(
      :type, :title, :description, :status, :isbn, :doi, :url,
      :pages,           # Book
      :duration_minutes # Video
    )
  end
end
