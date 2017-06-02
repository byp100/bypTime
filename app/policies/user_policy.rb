class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :model

  def initialize current_user, model
    @current_user = current_user
    @user = model
  end

  def index?
    @current_user.admin?
  end

  def create?
    @current_user.admin?
  end

  def show?
    @current_user.admin? or is_current_user?
  end

  def edit?
    @current_user.admin? or is_current_user?
  end

  def update?
    @current_user.admin? or is_current_user?
  end

  def destroy?
    @current_user.admin? or is_current_user?
  end

  private

  def is_current_user?
    @current_user == @user
  end
end
