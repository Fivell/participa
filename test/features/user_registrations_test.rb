require "test_helper"
require "features/concerns/registration_helpers"

feature "UserRegistrations" do
  include Participa::Test::RegistrationHelpers

  before { @user = FactoryGirl.build(:user) }

  scenario "create a user in Catalonia", js: true do
    base_register(@user) do
      fill_in_location_data(country: 'España',
                            province: 'Barcelona',
                            town: 'Badalona',
                            postal_code: '08008')
    end

    assert_location 'Badalona, Barcelona, España', User.first
  end

  scenario "create a user outside of Catalonia", js: true do
    base_register(@user) do
      fill_in_location_data(country: 'España',
                            province: 'Albacete',
                            town: 'Albacete',
                            postal_code: '02002')
    end

    assert_location 'Albacete, Albacete, España', User.first
  end

  scenario "create a user outside of Spain", js: true do
    base_register(@user) do
      fill_in_location_data(country: 'Estados Unidos',
                            province: 'Alabama')
    end

    assert_location 'Alabama, Estados Unidos', User.first
  end

  scenario "create a user with gender identity information", js: true do
    visit new_user_registration_path
    fill_in_user_registration(@user, @user.document_vatid, @user.email)
    select 'Mujer cis', from: 'Identidad de género'
    click_button 'Inscribirse'

    page.must_have_content \
      I18n.t("devise.registrations.signed_up_but_unconfirmed")

    assert_equal true, User.first.gender_identity.cis_woman?
  end

  private

  def base_register(user)
    assert_equal 0, User.all.count
    visit new_user_registration_path
    fill_in_personal_data(user, user.document_vatid)
    yield
    fill_in_login_data(user, user.email)
    acknowledge_stuff
    click_button "Inscribirse"

    page.must_have_content \
      I18n.t("devise.registrations.signed_up_but_unconfirmed")
  end

  def assert_location(location, user)
    components = location.split(', ')

    if components.size == 3
      town, province, country = *components

      assert_equal town, user.town_name
    else
      province, country = *components
    end

    assert_equal province, user.province_name
    assert_equal country, user.country_name
  end
end
