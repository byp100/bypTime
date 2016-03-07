class AdminController < ApplicationController
  def dashboard
  	@users = User.joins(:memberships).where(memberships: {organization_id: current_tenant.id}).uniq
  	@events = Event.all
  end
end
