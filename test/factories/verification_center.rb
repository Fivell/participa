FactoryGirl.define do
  factory :verification_center, class: Verification::Center do
    name "Un lugar, pra relaxar"
    street "Rua Bella"
    city "Terrassa"
    latitude 1.0
    longitude -1.0

    trait :with_verification_slot do
      transient do
        starts_at { 1.day.ago }
        ends_at { 1.day.from_now }
      end

      after(:create) do |verification_center, evaluator|
        create(:verification_slot, verification_center: verification_center,
                                   starts_at: evaluator.starts_at,
                                   ends_at: evaluator.ends_at)
      end
    end
  end
end
