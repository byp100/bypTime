require 'rails_helper'

def member_logged_in!(member=create(:member))
  @logged_in_member = member
  allow(controller).to receive(:authenticate_user!)
  allow(controller).to receive(:current_member).and_return(@logged_in_member)
end