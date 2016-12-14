require "test_helper"
require "features/concerns/registration_helpers"

feature "UsersAreParanoid" do
  include Participa::Test::RegistrationHelpers

  before { @user = FactoryGirl.build(:user) }

  scenario "regular registration", js: true do
    # first creation attempt, receive OK message and create it
    assert_equal 0, User.all.count
    create_user_registration(@user, @user.document_vatid, @user.email)
    page.must_have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")
    assert_equal 1, User.all.count
  end

  scenario "creation with dup document and email", js: true do
    @user.save!
    # receive OK message
    # but don't create the user and mail them a message
    create_user_registration(@user, @user.document_vatid, @user.email)
    page.must_have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")
    assert_equal 1, User.all.count
  end

  scenario "creation with same document and invalid email", js: true do
    @user.save!
    # receive KO message
    # don't create it because it has errors.
    # should receive validation error.
    create_user_registration(@user, @user.document_vatid, "trolololo")
    page.must_have_content "La dirección de correo es incorrecta"
    assert_equal 1, User.all.count
  end

  scenario "creation the same document and different email", js: true do
    @user.save!
    # receive OK message
    # but don't create the user and mail them a message to original account
    create_user_registration(@user, @user.document_vatid, "trolololo@example.com")
    page.must_have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")
    assert_equal 1, User.all.count
  end

end
