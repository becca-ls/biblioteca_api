# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # IMPORTANTE: sobrescreve create para não usar sessão
  def create
    build_resource(sign_up_params)
    resource.save

    if resource.persisted?
      # faz login sem session store (API)
      sign_in(resource_name, resource, store: false)

      render json: {
        message: "signed up",
        user: { id: resource.id, email: resource.email }
      }, status: :created
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
