class User < ActiveRecord::Base
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  validates :phone, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :attendances
  has_many :events, through: :attendances
  has_many :memberships
  has_many :organizations, through: :memberships

  attr_accessor :in_attendance

  enum role: [:guest, :member, :admin]
  enum gender: [:agender, :androgyne, :androgynous, :bigender, :cis, :cisgender, :cisgender_female, :cisgender_male, :cisgender_man, :cisgender_woman, :female_to_male, :gender_fluid, :gender_nonconforming, :gender_questioning, :gender_variant, :genderqueer, :male_to_female, :neither, :neutrois, :non_binary, :other, :pangender, :transgender, :transgender_person, :transgender_female, :transgender_male, :transgender_man, :transgender_woman, :transmasculine, :transfeminine, :transsexual, :transsexual_female, :transsexual_male, :transsexual_man, :transsexual_woman, :transsexual_person, :two_spirit]
  enum sexual_orientation: [:androgynosexual, :androsexual, :asexual, :autosexual, :bisexual, :demisexual, :gray_a, :gynosexual, :heterosexual, :heteroflexible, :homosexual, :homoflexible, :objectumsexual, :omnisexual, :polysexual, :queer, :skoliosexual]
  enum committee_membership: [:membership, :treasury, :secretary, :leadership_development, :organizing, :communications, :fundraising]
  enum education_level: [:less_than_high_school, :high_school_diploma, :some_college, :postsecondary_non_degree_award, :associates_degree, :bachelors_degree, :masters_degree, :doctoral_degree]
  enum partnership_status: [:single, :dating, :engaged, :married, :open_relationship, :widowed, :separated, :divorced, :civil_union, :domestic_partnership, :complicated]
  enum income: [:hourly_wage, :annual_salary]

  after_initialize :set_default_role, if: :new_record?


  def rsvp? event
    events.include? event
  end

  def in_attendance? event
    attendance = Attendance.find_by(user_id: self.id, event_id: event.id)
    attendance.in_attendance
  end

  def set_default_role
    self.role ||= :guest
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def eligible_for_membership?
    if attendances.where(event_type: "orientation").count == 1 && attendances.where(event_type: "general_body_meeting").count == 2 && attendances.where(event_type: "public_event").count == 1
      return true
    else
      return false
    end
  end

  def begin_enrollment
    twilio = TwilioService.new
    twilio.send("Welcome, you have completed the attendance requirements for BYP100 membership, please pay your dues at www.byp100.org", phone)
  end

  aasm do
    state :prospective, :initial => true
    
    state :active 

    state :inactive

    state :alumni

    event :induct do
      transitions :from => [:prospective], :to => :active
    end

    event :deactivate do
      transitions :from => [:active], :to => :inactive
    end

    event :activate do
      transitions :from => [:inactive], :to => :active
    end

    event :graduate do
      transitions :from => [:active], :to => :alumni
    end
  end
end
