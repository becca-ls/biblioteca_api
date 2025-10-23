class MaterialsController < ApplicationController
  before_action :set_material, only: %i[show update destroy]
  def index
    q = policy_scope(Material).includes(:authors).ransack(params[:q])
    materials = q.result.order(created_at: :desc).page(params[:page]).per(params[:per] || 20)

    render json: {
      data: materials.as_json(include: { authors: { only: %i[id name kind] } }),
      meta: {
        page:        materials.current_page,
        per:         materials.limit_value,
        total_pages: materials.total_pages,
        total_count: materials.total_count
      }
    }
  end
  def show
    authorize @material
    render json: @material.as_json(include: { authors: { only: %i[id name kind] } })
  end
  def create
    authorize Material
    klass     = material_klass
    owner     = respond_to?(:current_user) ? current_user : nil
    @material = klass.new(material_params.merge(user: owner))

    if @material.save
      render json: @material.as_json(include: { authors: { only: %i[id name kind] } }), status: :created
    else
      render json: { errors: @material.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def update
    authorize @material
    if @material.update(material_params)
      render json: @material.as_json(include: { authors: { only: %i[id name kind] } })
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
  
  def set_material
    @material = Material.find(params[:id])
  end
  def material_klass
    type = params.dig(:material, :type)
    return Material if type.blank?
    return Material unless Material::ALLOWED_TYPES.include?(type)
    type.constantize
  end
  def material_params
    params.require(:material).permit(
      :type, :title, :description, :status, :isbn, :doi, :url,
      :pages, :duration_minutes,
      authorships_attributes: [:author_id, :role, :_destroy]
    )
  end
end
