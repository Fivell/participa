FactoryGirl.define do

  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :document_vatid do |n|
    "83482#{n}D"
  end

  sequence :phone do |n|
    "003466111111#{n}"
  end

  factory :user do
    last_name "Pepito"
    first_name "Perez"
    # FIXME: reutilice email_confirmation
    email 
    email_confirmation { email }
    password '123456789'
    confirmed_at Time.now
    born_at Date.civil(1983, 2, 1) 
    wants_newsletter true
    document_type 3
    document_vatid 
    admin false
    address "C/ Inventada, 123" 
    town "Madrid"
    province "M"
    postal_code "28021"
    country "ES"
    phone
    sms_confirmed_at DateTime.now
  end

  trait :admin do
    admin true
  end

  trait :legacy_password_user do
    has_legacy_password true
  end

  trait :sms_non_confirmed_user do
    sms_confirmed_at nil
  end

  trait :no_newsletter_user do
    wants_newsletter false
  end

  trait :newsletter_user do
    wants_newsletter true
  end

end
