FactoryBot.define do
  factory :league do
    sequence(:name) { |n| "League #{n}" }
    draft_status { League.draft_statuses.keys.sample }
    sequence(:draft_date_time) { |n| DateTime.now + n.days }
  end
end
