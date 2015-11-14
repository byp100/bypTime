class Event < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, through: :attendances, source: :member
  accepts_nested_attributes_for :attendees

  validates :title, presence: true
  validates :start_time, presence: true
  validates :event_type, presence: true

  enum event_type: [:orientation, :general_body_meeting, :public_event]

  def number_of_attendees
    attendees.size
  end
end
