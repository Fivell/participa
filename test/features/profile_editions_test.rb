require "test_helper"

feature "ProfileEditions" do
  before do
    @user = FactoryGirl.create(:user, email: 'pepe@example.org',
                                      password: '111111',
                                      confirmed_at: Time.zone.now)
    visit root_path
    fill_in 'Correo electrónico o Nº de documento', with: 'pepe@example.org'
    fill_in 'Contraseña', with: '111111'
    click_button 'Iniciar sesión'
  end

  scenario "can edit profile", js: true do
    click_link "Datos personales"
    fill_in "Dirección", with: "Mi nueva casa"
    fill_in "Contraseña actual", with: "111111", match: :first
    click_button "Actualizar datos"

    assert_text "Has actualizado tu cuenta correctamente."
    assert_equal "Mi nueva casa", @user.reload.address
  end

  scenario "form errors preserve changed data", js: true do
    click_link "Datos personales"
    select "Brasil", from: "País"
    click_button "Actualizar datos"

    assert_text "No se han podido actualizar los datos"
    assert page.has_select?('País', selected: 'Brasil')
  end
end
