class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_member?
    return current_member != nil
  end

  def after_sign_in_path_for resource
    sign_in_url = new_member_session_url
    if request.referer == sign_in_url
      member_path current_member
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def after_sign_out_path_for resource
    stored_location_for(resource) || request.referer || root_path
  end
end
