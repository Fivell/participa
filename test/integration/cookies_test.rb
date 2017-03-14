require "test_helper"

class CookiesTest < JsFeatureTest
  test "dismissing cookie alert applies to all site" do
    visit new_user_registration_path(locale: 'es')
    click_link 'cerrar aviso'

    visit new_user_registration_path(locale: 'ca')
    assert_no_text 'cerrar aviso'
  end
end
