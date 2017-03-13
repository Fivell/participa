require "test_helper"

feature "VerificationPresencial" do

  before do
    @prev_verification_presential = Rails.application.secrets.features["verification_presencial"]
    Rails.application.secrets.features["verification_presencial"] = true

    # Routes are defined conditionally on the presence of this feature
    Rails.application.reload_routes!
  end

  after do
    Rails.application.secrets.features["verification_presencial"] = @prev_verification_presential

    # Leave routes as they were previously
    Rails.application.reload_routes!
  end

  scenario "user should verificate to access tools", js: true do

    # cant access as anon
    visit verification_step1_path
    assert_equal page.current_path, root_path(locale: :es)

    # initialize
    user = create(:user)
    election = create(:election)

    # should see the pending verification message if isn't verified
    login_as(user)
    visit root_path
    page.must_have_content I18n.t('verification.pending0_html')

    # can't access verification admin
    visit verification_step1_path
    assert_equal page.current_path, root_path(locale: :es)

    # can't access vote
    visit create_vote_path(election_id: election.id)
    #page.must_have_content I18n.t('app.unauthorized')

  end

  scenario "user verifications_admin can verify", js: true do

    # should see the pending verification message if isn't verified
    user2 = create(:user)
    login_as(user2)
    visit root_path
    #page.must_have_content I18n.t('verification.pending0_html')
    logout(user2)
    Capybara.reset_sessions!

    # user1 can verify to user2
    user1 = create(:user)
    user1.verifications_admin = true
    user1.save
    login_as(user1)
    visit verification_step1_path
    page.must_have_content I18n.t('verification.form.document')
    check('user_document')
    check('user_town')
    check('user_age_restriction')
    click_button('Siguiente')
    fill_in(:user_email, with: user2.email)
    click_button('Siguiente')
    page.must_have_content I18n.t('verification.result')
    click_button('Si, estos datos coinciden')
    page.must_have_content I18n.t('verification.alerts.ok.title')
    logout(user1)

    # should see the OK verification message
    login_as(user2)
    visit root_path
    page.must_have_content I18n.t('voting.election_none')
    logout(user2)
  end

end
