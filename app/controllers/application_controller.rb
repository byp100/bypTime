class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  set_current_tenant_through_filter
  before_filter :set_organization_as_tenant

  protect_from_forgery with: :exception

  helper_method :chapter?

  def current_user?
    return current_user != nil
  end

  def member?
    if current_member.memberships.find_by(organization_id:current_tenant.id)
    end
  end

  def chapter?
    Chapter.friendly.exists?(request.subdomain)
  end

  def after_sign_in_path_for resource
    sign_in_url = new_user_session_url
    if request.referer == sign_in_url
      user_path current_user
    else
      stored_location_for(resource) || request.referer || root_path
    end
  end

  def set_organization_as_tenant
    organization = Organization.friendly.find(request.subdomain)
    if organization.is_a? Chapter
      set_current_tenant(organization)
    end
  end

  def current_tenant
    Organization.friendly.find(request.subdomain)
  end

  def after_sign_out_path_for resource
    stored_location_for(resource) || request.referer || root_path
  end
end
