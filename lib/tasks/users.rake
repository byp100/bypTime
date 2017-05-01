namespace :users do
  desc 'Update role based on membership requirements'
  task membership_status: :environment do
    User.all.each do |user|
      next if user.role == 'admin'
      orientations = Event.joins(:attendances).where(event_type: 0, attendances: { user_id: user.id, in_attendance: true } )
      general_body_meetings = Event.joins(:attendances).where(event_type: 1, attendances: { user_id: user.id, in_attendance: true } )
      public_events = Event.joins(:attendances).where(event_type: 2, attendances: { user_id: user.id, in_attendance: true } )

      if orientations.size > 0 and public_events.size > 0 and general_body_meetings.size > 1
        user.update_attributes(role: 'member')
      else
        user.update_attributes(role: 'guest')
      end
    end
  end

  desc "Clean up phone numbers"
  task sanitize_phone: :environment do
    User.all.each do |user|
      user.update_attributes(phone: user.phone.gsub(/\D/, ''))
      puts "Name: #{user.name} Phone: #{user.phone}"
    end
  end
end
