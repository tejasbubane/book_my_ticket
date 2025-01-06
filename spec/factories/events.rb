FactoryBot.define do
  factory :event do
    name { Faker::Movie.title }
    description { Faker::Movie.quote }
    location { Faker::Movies::HarryPotter.location }
    starts_at { 2.hours.from_now }
    ends_at { 3.hours.from_now }
    total_tickets_count { 50 }
    sold_tickets_count { 50 }
    association :creator, factory: :user
  end
end
