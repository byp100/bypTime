require 'rails_helper'

describe User do
  before :each do
    @user = create :user
    @event = create :event
  end

  it 'has a valid factory' do
    @user.should be_valid
  end
  it 'is invalid without a phone number' do
    user = build :user, phone: nil
    user.should_not be_valid
  end

  it 'is invalid without a name' do
    user = build :user, name: nil
    user.should_not be_valid
  end

  describe '#rsvp?' do
    it 'returns false if user does not have rsvp for the event' do
      expect(@user.rsvp? @event).to be_falsey
    end

    it 'returns true if user has rsvp for the event' do
      @event.attendees << @user

      expect(@user.rsvp? @event).to be_truthy
    end

  end

  describe '#in_attendance?' do
    it 'returns false if user has not been marked in attendance of event' do
      attendance = create :attendance, user_id: @user.id, event_id: @event.id
      attendance.update_attribute('in_attendance', false)

      expect(@user.in_attendance? @event).to be_falsey
    end

    it 'returns true if user has been marked as being in attendance of the event' do
      attendance = create :attendance, user_id: @user.id, event_id: @event.id
      attendance.update_attribute('in_attendance', true)

      expect(@user.in_attendance? @event).to be_truthy
    end
  end
end