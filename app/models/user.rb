class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  validates :phone, presence: true, uniqueness: true
  validates :name, presence: true

  has_many :attendances
  has_many :events, through: :attendances

  attr_accessor :in_attendance

  enum gender: [:agender, :androgyne, :androgynous, :bigender, :cis, :cisgender, :cisgender_female, :cisgender_male, :cisgender_man, :cisgender_woman, :female_to_male, :gender_fluid, :gender_nonconforming, :gender_questioning, :gender_variant, :genderqueer, :male_to_female, :neither, :neutrois, :non_binary, :other, :pangender, :transgender, :transgender_person, :transgender_female, :transgender_male, :transgender_man, :transgender_woman, :transmasculine, :transfeminine, :transsexual, :transsexual_female, :transsexual_male, :transsexual_man, :transsexual_woman, :transsexual_person, :two_spirit]
  enum sexual_orientation: [:androgynosexual, :androsexual, :asexual, :autosexual, :bisexual, :demisexual, :gray_a, :gynosexual, :heterosexual, :heteroflexible, :homosexual, :homoflexible, :objectumsexual, :omnisexual, :polysexual, :queer, :skoliosexual]
  enum committee_membership: [:membership, :treasury, :secretary, :leadership_development, :organizing, :communications, :fundraising]
  enum education_level: [:less_than_high_school, :high_school_diploma, :some_college, :postsecondary_non_degree_award, :associates_degree, :bachelors_degree, :masters_degree, :doctoral_degree]
  enum partnership_status: [:single, :dating, :engaged, :married, :open_relationship, :widowed, :separated, :divorced, :civil_union, :domestic_partnership, :complicated]
  enum income: [:hourly_wage, :annual_salary]


  def rsvp? event
    events.include? event
  end

  def in_attendance? event
    attendance = Attendance.find_by(user_id: self.id, event_id: event.id)
    attendance.in_attendance
  end

  #for Devise so that primary id is phone number instead of email
  def email_required?
    false
  end

  def email_changed?
    false
  end
end
