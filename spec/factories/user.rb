FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "fake#{n}@fake.com" }
    password "password"
  end
end
