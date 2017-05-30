FactoryGirl.define do
  factory :user do
    phone { rand(10**9..10**10) }
    password 'p@ssw0rd'
    name Faker::Name.name
    email { Faker::Internet.email(name) }
    role 'guest'

    trait :admin do
      role 'admin'
    end

    trait :member do
      role 'member'
    end

    trait :guest do
      role 'guest'
    end
  end
end