class Event < ActiveRecord::Base
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :member

  def number_of_attendees
    attendees.count
  end
end
