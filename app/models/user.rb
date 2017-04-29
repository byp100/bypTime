class User < ActiveRecord::Base
  include AASM
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable,
         :authentication_keys => [:phone]

  validates :phone, presence: true, uniqueness: true, format: { with: /\d{10}/ }
  validates :name, presence: true

  has_many :attendances
  has_many :events, through: :attendances
  has_many :memberships, foreign_key: "member_id"
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


  scope :active, -> { where(:aasm_state => "active") }


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

  def self.import(file, organization)
    file_path = file.tempfile.to_path
    xlsx = Roo::Excelx.new(file_path)
    xlsx.default_sheet = xlsx.sheets.first

    row_count = 0

    event_count = 0

    event_data = []

    xlsx.each_row_streaming(pad_cells: true) do |row|

      row_items = row

      if row_count == 0

        row_items.each_with_index do |item, index|
          item = item.value
          if index > 3
            if item.present?
              event_type = "public_event"
              if item == "Orientation"
                event_type = "orientation"
              elsif item == "Meeting"
                event_type = "general_body_meeting"
              end
              event_data.push({
                event_type: event_type,
                attendances: []
              })
            else
              event_data.push({
              })
            end
          end

        end

      elsif row_count == 1
        row_items.each_with_index do |item, index|
          item = item.value
          if index > 3
            event_data[index - 4][:date] = item
          end
        end
      elsif row_count == 2

        row_items.each_with_index do |item, index|
          item = item.value
          if index > 3
            if item.blank?
              event_data[index - 4][:title] = "Event"
            else
              event_data[index - 4][:title] = item
            end
          end
        end

      elsif row_count >= 3
        user_data = {}
        row_items.each_with_index do |item, index|
          if item.present?
            item = item.value
            if index == 0
              user_data[:name] = item
            elsif index == 1
              user_data[:phone] = item
            elsif index == 3
              user_data[:email] = item
            end
            user = nil
            if index == 4
              user = User.find_by(phone: user_data[:phone].to_s) if user_data[:phone].present?
              if user.nil?
                user = User.create(name: user_data[:name], phone: user_data[:phone].to_i.to_s, email: user_data[:email], password: "password", password_confirmation: "password")
                user.memberships.create!(organization: organization) if user.id.present?
              end

            end
            if index >= 4
              event_data[index - 4][:attendances].push(user.id) if item.present? && user.present?
            end
            user = nil
          else
            if index == 0
              break
            end
          end
        end
      end  

      row_count += 1
    end
    event_data.each do |data|
      if data[:event_type].present?
        datetime = data[:date].to_datetime
        if Event.find_by(start_time: datetime.beginning_of_day..datetime.end_of_day).nil?
          event = Event.find_or_create_by!(event_type: data[:event_type].downcase, start_time: data[:date].to_datetime, end_time: data[:date].to_datetime, title: data[:title])
          data[:attendances].each do |user_id|
            event.attendances.create(user_id: user_id)
          end
        end
      end

    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def admin?(current_tenant)
    if super_admin
      true
    else
      Membership.find_by(organization_id: current_tenant.id, member_id: id).admin
    end
  end

  def eligible_for_membership?
    if attendances.joins(:event).where(events: {event_type: 'orientation' }).count >= 1 && attendances.joins(:event).where(events: {event_type: 'general_body_meeting' }).count >= 2 && attendances.joins(:event).where(events: {event_type: 'public_event' }).count >= 1
      return true
    else
      return false
    end
  end

  def pending_invoices?
    Billing::Invoice.list_invoices(customer_id).select{|result| result.invoice.status == "pending"}.count > 0
  end

  def begin_enrollment
    twilio = TwilioService.new
    twilio.send("Welcome, you have completed the attendance requirements for BYP100 membership, please pay your dues at www.byp100.org", phone)
  end

   def subscribed?(plan = nil)
    if plan == nil
      if customer_id.present?
        result = ChargeBee::Subscription.retrieve(customer_id)
        subscription = result.subscription
        if subscription.status != "cancelled" && subscription.status != "future" && subscription.status != "non_renewing"
          true
        else
         false
        end
      else
        false
      end
    else
      aasm_state == plan
    end
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
