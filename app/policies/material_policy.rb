# app/policies/material_policy.rb
class MaterialPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.present?
        scope.where("status = ? OR user_id = ?", "published", user.id)
      else
        scope.where(status: "published")
      end
    end
  end

  def show?
    return true if record.published? # qualquer um pode ver publicados
    user_owns?
  end

  def create?
    user.present?
  end

  def update?
    user_owns?
  end

  def destroy?
    user_owns?
  end

  private

  def user_owns?
    user.present? && record.user_id == user.id
  end
end
