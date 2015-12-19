namespace :chicago_events do
  desc 'Associate all current events with the Chicago chapter'
  task associate: :environment do
    Event.all.each do |event|
      event.update_attributes(chapter_id: 1)
    end
  end
end
