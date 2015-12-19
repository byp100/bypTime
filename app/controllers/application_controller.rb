class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_chapter

  def current_user?
    return current_user != nil
  end

  def after_sign_in_path_for resource
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      user_path current_user
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for resource
    stored_location_for(resource) || request.referer || root_path
  end

  private

  def get_chapter
    chapters = Chapter.where(subdomain: request.subdomain)

    if chapters.count > 0
      @chapter = chapters.first
    elsif request.subdomain != 'www'
      redirect_to root_url(subdomain: 'www')
    end
  end
end
