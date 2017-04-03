require "test_helper"

class ProfileEditionsTest < JsFeatureTest
  setup do
    @user = create(:user,
                   :confirmed_by_sms,
                   email: 'pepe@example.org',
                   password: '111111',
                   confirmed_at: Time.zone.now)
    visit root_path
    fill_in 'Correo electrónico o Nº de documento', with: 'pepe@example.org'
    fill_in 'Contraseña', with: '111111'
    click_button 'Iniciar sesión'
  end

  test "can edit profile" do
    click_link "Datos personales"
    fill_in "Dirección", with: "Mi nueva casa"
    fill_in "Contraseña actual", with: "111111", match: :first
    click_button "Actualizar datos"

    assert_text "Has actualizado tu cuenta correctamente."
    assert_equal "Mi nueva casa", @user.reload.address
  end

  test "users without a phone can visit profile edition" do
    @user.update(sms_confirmed_at: nil, phone: nil)
    click_link "Datos personales"

    assert_title "Datos personales"
  end

  test "users not having started online verification can't see documents tab" do
    with_verifications(online: true) do
      click_link "Datos personales"

      refute_content "MIS DOCUMENTOS"
    end
  end

  test "form errors preserve changed data" do
    click_link "Datos personales"
    select "Brasil", from: "País"
    click_button "Actualizar datos"

    assert_text "No se han podido actualizar los datos"
    assert_select 'País', selected: 'Brasil'
  end

  test "can change password" do
    change_password('222222', '222222', '111111')

    assert_text "Has actualizado tu cuenta correctamente"
  end

  test "change passwords shows errors and goes back to form" do
    change_password('222222', '222223', '111111')

    assert_text "Tu contraseña no coincide con la confirmación"
    assert_selector "h2", text: "Cambiar contraseña"
  end

  test "can switch from a spanish to a foreign location" do
    click_link "Datos personales"
    select "Brasil", from: "País"
    select "Rio de Janeiro", from: "Provincia"
    fill_in "Código postal", with: "2950-000"
    fill_in "Contraseña actual", with: "111111", match: :first
    click_button "Actualizar datos"

    assert_text "Has actualizado tu cuenta correctamente."
    assert_equal "BR", @user.reload.country
  end

  private

  def change_password(new_pass, new_pass_confirmation, current_pass)
    click_link "Datos personales"
    click_link "Cambiar contraseña"

    within '#change-password' do
      fill_in "user[password]", with: new_pass
      fill_in "user[password_confirmation]", with: new_pass_confirmation
      fill_in "user[current_password]", with: current_pass
      click_button 'Cambiar contraseña'
    end
  end
end
