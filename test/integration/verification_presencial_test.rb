require "test_helper"

class VerificationPresencialTest < JsFeatureTest

  setup do
    @prev_verification_presential = available_features["verification_presencial"]
    available_features["verification_presencial"] = true

    # Routes are defined conditionally on the presence of this feature
    Rails.application.reload_routes!
  end

  teardown do
    available_features["verification_presencial"] = @prev_verification_presential

    # Leave routes as they were previously
    Rails.application.reload_routes!
  end

  test "users need to be verified to access other tools" do

    # cant access as anon
    visit verification_step1_path
    assert_equal page.current_path, root_path(locale: :es)

    # initialize
    user = create(:user)
    election = create(:election)

    # should see the pending verification message if isn't verified
    login_as(user)
    visit root_path
    assert_content I18n.t('verification.pending0_html')

    # can't access verification admin
    visit verification_step1_path
    assert_equal page.current_path, root_path(locale: :es)

    # can't access vote
    visit create_vote_path(election_id: election.id)
    #assert_content I18n.t('app.unauthorized')

  end

  test "presential verifiers can verify users presentially" do

    # should see the pending verification message if isn't verified
    user2 = create(:user)
    login_as(user2)
    visit root_path
    #assert_content I18n.t('verification.pending0_html')
    logout(user2)
    Capybara.reset_sessions!

    # user1 can verify to user2
    user1 = create(:user)
    user1.verifications_admin = true
    user1.save
    login_as(user1)
    visit verification_step1_path
    assert_content I18n.t('verification.form.document')
    check('user_document')
    check('user_town')
    check('user_age_restriction')
    click_button('Siguiente')
    fill_in(:user_email, with: user2.email)
    click_button('Siguiente')
    assert_content I18n.t('verification.result')
    click_button('Si, estos datos coinciden')
    assert_content I18n.t('verification.alerts.ok.title')
    logout(user1)

    # should see the OK verification message
    login_as(user2)
    visit root_path
    assert_content I18n.t('voting.election_none')
    logout(user2)
  end

end
