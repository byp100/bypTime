require 'faker'
require 'factory_girl'

namespace :staging do
  desc 'Setup sample data in staging environment'
  task data_setup: :environment do
    3.times do
      city = Faker::Address.city
      organization = FactoryGirl.create(:organization,
                                        name: city,
                                        type: 'Chapter',
                                        slug: city.downcase.delete(' '),
                                        short_name: city.downcase.delete(' '))

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
    end

    FactoryGirl.create(:user,
                       phone: '3125551000',
                       password: 'p@ssw0rd',
                       role: 'admin',
                       super_admin: true)
  end
end