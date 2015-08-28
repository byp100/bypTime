class Event < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, through: :attendances, source: :member
  accepts_nested_attributes_for :attendees

  enum event_type: [:orientation, :general_body_meeting, :public_event]

  def number_of_attendees
    attendees.count
  end
end
