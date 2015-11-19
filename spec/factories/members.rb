FactoryGirl.define do
  factory :member do |f|
    f.phone { rand(10**9..10**10) }
    f.password 'p@ssw0rd'
    f.name 'Angela Davis'
    f.email 'sample@gmail.com'
  end
end