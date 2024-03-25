FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    seed { 1 }
    region { 'East' }
    conference { 'ACC' }
    other_conference { nil }
  end
end
