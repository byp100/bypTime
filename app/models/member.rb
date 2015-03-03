class Member < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  has_many :events

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
