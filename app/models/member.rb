class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  attr_accessor :in_attendance

  has_many :attendances
  has_many :events, through: :attendances

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def attending?(event)
    events.include?(event)
  end

  def in_attendance? event
    attendance = Attendance.find_by event.id
    attendance.in_attendance?
  end
end
