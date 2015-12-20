FactoryGirl.define do
  factory :event do
    title 'Event'
    description 'Event description goes here.'
    start_time Time.now
    event_type :orientation

    trait :orientation do
      title 'Membership Orientation'
      description "we are solving the problem of attendance maintenance so that attendance, becoming a member, and active membership is transparent across the entire organization. In addition, we are moving towards developing the most robust and largest database of Black youth organizers in the country."
      event_type :orientation
    end

    trait :general_body_meeting do
      title 'General Body Meeting'
      description 'This is a general body meeting where we discuss the latest events and strategize on things moving forward'
      event_type :general_body_meeting
    end

    trait :public_event do
      title 'Protest'
      description 'Meet us downtown at the mayors office to unite against oppression and structural racism'
      event_type :public_event
    end
  end
end