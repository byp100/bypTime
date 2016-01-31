class AdminController < ApplicationController
  def dashboard
  	@users = User.all
  	@events = Event.all
  end
end
