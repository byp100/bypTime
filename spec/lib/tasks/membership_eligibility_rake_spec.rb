require 'rails_helper'

describe 'membership_eligibility:event_requirements' do
  include_context 'rake'

  before do
    @user = create :user, :guest
    @ineligible_user = create :user, :member
    @admin_user = create :user, :admin

    @orientation = create :event, :orientation
    @public_event = create :event, :public_event
    @general_body_meeting = create :event, :general_body_meeting
    @second_general_body_meeting = create :event, :general_body_meeting

    Event.all.map do |event|
      event.attendees << @user
    end

    Attendance.all.map do |attendance|
      attendance.update_attributes(in_attendance: true)
    end
  end

  it 'sets eligibility correctly' do
    subject.invoke # Rake::Task['membership_eligibility:event_requirements'].invoke
    @user.reload
    @ineligible_user.reload
    @admin_user.reload

    expect(@user.role).to eq 'member'
    expect(@ineligible_user.role).to eq 'guest'
    expect(@admin_user.role).to eq 'admin'
  end
end