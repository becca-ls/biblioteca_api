class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :update, :destroy]

  # GET /materials
    def index
    @q = policy_scope(Material).ransack(params[:q])
    @materials = @q.result(distinct: true).page(params[:page]).per(5)

    safe_q = params[:q].present? ? params[:q].to_unsafe_h : nil

    render json: {
        data: @materials,
        meta: {
        current_page: @materials.current_page,
        total_pages:  @materials.total_pages,
        total_count:  @materials.total_count,
        per_page:     @materials.limit_value
        },
        links: {
        self: url_for(only_path: true, controller: :materials, action: :index,
                        page: @materials.current_page, q: safe_q),
        next: (@materials.next_page &&
                url_for(only_path: true, controller: :materials, action: :index,
                        page: @materials.next_page, q: safe_q)),
        prev: (@materials.prev_page &&
                url_for(only_path: true, controller: :materials, action: :index,
                        page: @materials.prev_page, q: safe_q))
        }
    }
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
