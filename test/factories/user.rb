FactoryGirl.define do

  sequence :email do |n|
    "foo#{n}@example.com"
  end

  sequence :document_vatid do |n|
    "#{n.to_s.rjust(8,'0')}#{'TRWAGMYFPDXBNJZSQVHLCKE'[n % 23].chr}"
  end

  sequence :phone do |n|
    "003466111111#{n}"
  end

  factory :user do
    last_name "Pepito"
    first_name "Perez"
    email 
    password '123456789'
    confirmed_at Time.now
    born_at Date.civil(1983, 2, 1) 
    wants_newsletter true
    document_type 1
    document_vatid 
    admin false
    spanish
    address "C/ Inventada, 123" 
    vote_town "m_28_079_6"
    phone
    #sms_confirmed_at DateTime.now
    flags 0
  end

  trait :catalan do
    transient do
      comarca 13
      vegueria "AT01"
    end

    country "ES"
    province "B"
    town "m_08_019_3"
    postal_code "08001"

    catalan_town do
      create(:catalan_town, code: town,
                            comarca_code: comarca,
                            vegueria_code: vegueria)
    end
  end

  trait :spanish do
    country "ES"
    province "M"
    town "m_28_079_6"
    postal_code "28021"
  end

  trait :foreigner do
    country "BR"
    province "RJ"
    town nil
    postal_code "2950-000"
  end

  trait :admin do
    admin true
  end

  trait :superadmin do
    superadmin true
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

  trait :foreign do
    document_type 3
    sequence(:document_vatid) { |n| "83482#{n}D" }
  end

  trait :island do
    province "IB"
    postal_code "07021"
    town "m_07_003_3"
  end
end
