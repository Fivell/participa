require "test_helper"
require "features/concerns/registration_helpers"

feature "UserRegistrations" do
  include Participa::Test::RegistrationHelpers

  def setup
    super

    @user = FactoryGirl.build(:user)
  end

  scenario "catalonia_residence is checked by default", js: true do
    visit new_user_registration_path

    assert page.has_checked_field?("Resido en Cataluña")
  end

  scenario "create a user in Catalonia", js: true do
    base_register(@user) do
      fill_in_location_data(province: 'Barcelona',
                            town: 'Badalona',
                            postal_code: '08008')
    end

    assert_location User.first, town: 'Badalona',
                                province: 'Barcelona',
                                country: 'España'
  end

  scenario "create a user outside of Catalonia", js: true do
    base_register(@user) do
      fill_in_location_data(country: 'España',
                            province: 'Albacete',
                            town: 'Albacete',
                            postal_code: '02002')
    end

    assert_location User.first, town: 'Albacete',
                                province: 'Albacete',
                                country: 'España'
  end

  scenario "create a user outside of Spain", js: true do
    base_register(@user) do
      fill_in_location_data(country: 'Estados Unidos', province: 'Alabama')
    end

    assert_location User.first, province: 'Alabama', country: 'Estados Unidos'
  end

  scenario "location is preserved upon form errors", js: true do
    visit new_user_registration_path
    fill_in_location_data(country: 'Estados Unidos', province: 'Alabama')
    click_button 'Inscribirse'

    assert page.has_select?('País', selected: 'Estados Unidos')
    assert page.has_select?('Provincia', selected: 'Alabama')
  end

  scenario "create a user with gender identity information", js: true do
    visit new_user_registration_path
    fill_in_user_registration(@user, @user.document_vatid, @user.email)
    select 'Mujer (cis)', from: 'Identidad de género'
    click_button 'Inscribirse'

    page.must_have_content \
      I18n.t("devise.registrations.signed_up_but_unconfirmed")

    assert_equal true, User.first.gender_identity.cis_woman?
  end

  scenario "captcha skipped", js: true do
    visit new_user_registration_path
    fill_in_personal_data(@user, @user.document_vatid)
    fill_in_location_data(province: 'Barcelona',
                          town: 'Barcelona',
                          postal_code: '08021')
    fill_in_login_data(@user, @user.email)
    acknowledge_terms
    acknowledge_age
    click_button 'Inscribirse'
    assert_text 'El texto introducido no corresponde con el de la imagen'
  end

  scenario "captcha skipped and another error", js: true do
    visit new_user_registration_path
    fill_in_personal_data(@user, @user.document_vatid)
    fill_in_location_data(province: 'Barcelona',
                          town: 'Barcelona',
                          postal_code: '08021')
    fill_in_login_data(@user, @user.email)
    acknowledge_age
    # Investigate and fix
    find_button('Inscribirse').trigger('click')
    assert_text 'El texto introducido no corresponde con el de la imagen'
    assert_text 'He leído las condiciones y acepto inscribirme'
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

  def assert_location(user, town: nil, province:,  country:)
    assert_equal town, user.town_name if town
    assert_equal province, user.province_name
    assert_equal country, user.country_name
  end
end
