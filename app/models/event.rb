class Event < ActiveRecord::Base
  has_many :attendances
  has_many :attendees, through: :attendances, source: :member

  def number_of_attendees
    attendees.count
  end
end
