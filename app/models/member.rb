class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  has_many :attendances
  has_many :events, through: :attendances
  
  attr_accessor :in_attendance

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def attending? event
    events.include? event
  end

  def in_attendance? event
    attendance = Attendance.find_by(member_id: self.id, event_id: event.id)
    attendance.in_attendance
  end
end
