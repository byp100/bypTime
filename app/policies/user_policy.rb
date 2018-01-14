class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize current_user, model
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.super_admin?
  end

  def create?
    @current_user.super_admin?
  end

  def show?
    @current_user.super_admin? or is_current_user?
  end

  def edit?
    @current_user.super_admin? or is_current_user?
  end

  def update?
    @current_user.super_admin? or is_current_user?
  end

  def destroy?
    @current_user.super_admin? or is_current_user?
  end

  def update_membership?
    @current_user.super_admin?
  end

  private

  def is_current_user?
    @current_user == @user
  end
end
