class AdminController < ApplicationController
  def dashboard
  	@users = User.where(id: User.joins(:memberships).where(memberships: {organization_id: current_tenant.id}).to_a.uniq.map{|u| u.id})
  	@events = Event.all
  end

  def import
  end
end
