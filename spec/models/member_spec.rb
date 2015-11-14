require 'rails_helper'

describe Member do
  before :each do
    @member = create :member
    @event = create :event
  end

  it 'has a valid factory' do
    @member.should be_valid
  end
  it 'is invalid without a phone number' do
    member = build :member, phone: nil
    member.should_not be_valid
  end

  it 'is invalid without a name' do
    member = build :member, name: nil
    member.should_not be_valid
  end

  describe '#rsvp?' do
    it 'returns false if member does not have rsvp for the event' do
      expect(@member.rsvp? @event).to be_falsey
    end

    it 'returns true if member has rsvp for the event' do
      @event.attendees << @member

      expect(@member.rsvp? @event).to be_truthy
    end

  end

  describe '#in_attendance?' do
    it 'returns false if member has not been marked in attendance of event' do
      attendance = create :attendance, member_id: @member.id, event_id: @event.id
      attendance.update_attribute('in_attendance', false)

      expect(@member.in_attendance? @event).to be_falsey
    end

    it 'returns true if member has been marked as being in attendance of the event' do
      attendance = create :attendance, member_id: @member.id, event_id: @event.id
      attendance.update_attribute('in_attendance', true)

      expect(@member.in_attendance? @event).to be_truthy
    end
  end
end