FactoryBot.define do
  sequence(:body) { |n| "#{n}-TextTextText" }

  factory :answer do
    user
    question
    body

    trait :invalid do
      body {nil}
    end
  end
end
