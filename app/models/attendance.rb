class Attendance < ActiveRecord::Base
  belongs_to :member
  belongs_to :event

  validates :member, presence: true
  validates :event, presence: true
end
