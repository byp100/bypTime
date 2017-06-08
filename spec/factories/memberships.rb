FactoryGirl.define do
  factory :membership do |f|
    f.organization_id 1
    f.member_id 1
    f.admin false
  end
end