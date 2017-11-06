class Event < ActiveRecord::Base
  acts_as_tenant(:organization)
  has_many :attendances
  has_many :attendees, through: :attendances, source: :user
  accepts_nested_attributes_for :attendees

  validates :title, presence: true
  validates :start_time, presence: true
  validates :event_type, presence: true

  geocoded_by :address
  after_validation :geocode

  enum event_type: [:orientation, :general_body_meeting, :public_event]

  def number_of_attendees
    attendees.size
  end

  def self.import file, chapter
    CSV.foreach(file.path, headers: true) do |row|
      event = Event.create! row.to_hash
      event.update(organization_id: chapter.id)
    end
  end
end
