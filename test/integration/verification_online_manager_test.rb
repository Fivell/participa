require "test_helper"
require "integration/concerns/login_helpers"
require "integration/concerns/verification_helpers"

class VerificationOnlineManagerTest < JsFeatureTest
  include Participa::Test::LoginHelpers
  include Participa::Test::VerificationHelpers

  around do |&block|
    with_verifications(online: true) do
      @user = create(:user, :confirmed_by_sms,
                            first_name: "Miguel",
                            last_name: "Miguelez")

      super(&block)
    end
  end

  setup do
    login create(:user, :verifying_online)
    visit online_verifications_path
    click_link('Comenzar')
    assert_content "Miguel Miguelez"
  end

  test "allows verifying users" do
    click_link('Aceptar')
    assert_content "No quedan usuarias pendientes de verificación. ¡Buen trabajo!"
    logout

    # should see the OK verification message
    login(@user)
    assert_content I18n.t('voting.election_none')
  end

  test "allows banning users" do
    click_link('Expulsar')
    assert_content "No quedan usuarias pendientes de verificación. ¡Buen trabajo!"
    logout

    # should see the banned message
    login(@user)
    assert_content I18n.t("unauthorized.banned", full_name: @user.full_name)
  end
end
