require 'rails_helper'

describe 'users:membership_status' do
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
    subject.invoke # Rake::Task['users:membership_status'].invoke
    @user.reload
    @ineligible_user.reload
    @admin_user.reload

    expect(@user.role).to eq 'member'
    expect(@ineligible_user.role).to eq 'guest'
    expect(@admin_user.role).to eq 'admin'
  end
end

describe 'users:sanitize_phone' do
  include_context 'rake'

  before do
    @user1 = build :user, phone: '(312) 555-1000'
    @user1.save validate: false

    @user2 = build :user, phone: '704.555.1000'
    @user2.save validate: false
  end

  it 'removes non numeric characters from phone numbers' do
    subject.invoke # Rake::Task['users:sanitize_phone'].invoke
    @user1.reload
    @user2.reload

    expect(@user1.phone).to eq '3125551000'
    expect(@user2.phone).to eq '7045551000'
  end
end