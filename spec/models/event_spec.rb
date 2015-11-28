require 'rails_helper'

describe Event do
  it 'has a valid factory' do
    event = create :event
    event.should be_valid
  end

  it 'is invalid without a title' do
    event = build :event, title: nil
    event.should_not be_valid
  end

  it 'is invalid without a start date/time' do
    event = build :event, start_time: nil
    event.should_not be_valid
  end

  it 'is invalid without an event_type' do
    event = build :event, event_type: nil
    event.should_not be_valid
  end

  describe '#number_of_attendees' do
    it 'returns the correct number of attendees' do
      event = create :event
      3.times do
        user = create :user
        event.attendees << user
      end

      expect(event.number_of_attendees).to eq 3
    end
  end
end