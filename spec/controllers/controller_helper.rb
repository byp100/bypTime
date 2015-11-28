require 'rails_helper'

def user_logged_in!(user=create(:user))
  @logged_in_user = user
  allow(controller).to receive(:authenticate_user!)
  allow(controller).to receive(:current_user).and_return(@logged_in_user)
end