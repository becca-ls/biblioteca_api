class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  private

  def forbidden
    render json: { error: "forbidden" }, status: :forbidden
  end
end
