# app/policies/material_policy.rb
class MaterialPolicy < ApplicationPolicy
  # policy_scope para o index
  class Scope < Scope
    def resolve
      # Anônimo: só vê públicos (não arquivados)
      return scope.where(archived: false) unless user

      # Logado: vê públicos + os que são dele
      scope.where(archived: false).or(scope.where(user_id: user.id))
    end
  end

  # Qualquer um pode ver material público;
  # materiais arquivados: só o dono.
  def show?
    return true unless record.archived?
    user_owns?
  end

  # criar: precisa estar logado
  def create?
    user.present?
  end

  # editar/apagar: só o dono
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
