FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    auth_token { SecureRandom.hex(16) }
    google_id { Faker::Number.number(digits: 10).to_s }
  end
end


