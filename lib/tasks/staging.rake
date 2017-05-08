require 'faker'
require 'factory_girl'

namespace :staging do
  desc 'Delete data in staging environment'
  task destroy_all: :environment do
    Organization.destroy_all
    User.destroy_all
    Event.destroy_all
    Membership.destroy_all
    Attendance.destroy_all
  end

  desc 'Setup sample data in staging environment'
  task data_setup: :environment do
    organization = FactoryGirl.create(:organization,
                       name: 'Staging',
                       type: 'Chapter',
                       slug: 'byptime-staging',
                       short_name: 'staging')


    20.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      name = "#{first_name} #{last_name}"

      user = FactoryGirl.create(:user,
                                phone: rand(10**9..10**10),
                                password: 'p@ssw0rd',
                                name: name,
                                email: Faker::Internet.safe_email(first_name),
                                role: 'member')

      Membership.create(organization_id: organization.id, member_id: user.id)
    end

    2.times do
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      name = "#{first_name} #{last_name}"

      user = FactoryGirl.create(:user,
                                phone: rand(10**9..10**10),
                                password: 'p@ssw0rd',
                                name: name,
                                email: Faker::Internet.safe_email(first_name),
                                role: 'admin')

      Membership.create(organization_id: organization.id, member_id: user.id)
    end

    3.times do
      event = FactoryGirl.create(:event,
                                 title: Faker::Hipster.sentence(5),
                                 description: Faker::Hipster.paragraph(3),
                                 start_time: Faker::Time.forward(21, :evening),
                                 event_type: :orientation,
                                 organization_id: organization.id)

      5.times do
        Attendance.create(user: User.offset(rand(User.count)).first, event: event)
      end
    end

    3.times do
      event = FactoryGirl.create(:event,
                                 title: Faker::Hipster.sentence(5),
                                 description: Faker::Hipster.paragraph(3),
                                 start_time: Faker::Time.forward(21, :evening),
                                 event_type: :general_body_meeting,
                                 organization_id: organization.id)

      5.times do
        Attendance.create(user: User.offset(rand(User.count)).first, event: event)
      end
    end

    3.times do
      event = FactoryGirl.create(:event,
                                 title: Faker::Hipster.sentence(5),
                                 description: Faker::Hipster.paragraph(3),
                                 start_time: Faker::Time.forward(21, :evening),
                                 event_type: :public_event,
                                 organization_id: organization.id)

      5.times do
        Attendance.create(user: User.offset(rand(User.count)).first, event: event)
      end
    end

    FactoryGirl.create(:user,
                       phone: '3125551000',
                       password: 'p@ssw0rd',
                       role: 'admin',
                       super_admin: true)
  end
end