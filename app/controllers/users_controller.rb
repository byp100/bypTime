class UsersController < ApplicationController
  def show
    @user = User.find params[:id]
    unless @user == current_user
      redirect_to root_path, :alert => "Access Denied"
    end
  end

  def index
    @users = User.all
  end
end
