namespace :membership_eligibility do
  desc 'Daily task to check whether each user is meeting their membership requirements'
  task event_requirements: :environment do
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
end
