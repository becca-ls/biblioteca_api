class ApplicationController < ActionController::API
  include ActionController::Helpers
  include Devise::Controllers::Helpers
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def pundit_user
    respond_to?(:current_user) ? current_user : nil
  end

  private
  def user_not_authorized
    render json: { error: "not authorized" }, status: :forbidden
  end
end
