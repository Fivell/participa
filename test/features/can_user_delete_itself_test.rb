require "test_helper"

def create_resource_and_delete_itself klass, factory, final_count
  assert_equal 0, klass.all.count 
  resource = create(factory)
  assert_equal 1, klass.all.count

  login_as(resource.user)
  visit edit_user_registration_path
  click_link "Darme de baja" # change tab
  click_button "Darme de baja"
  page.must_have_content "¡Adiós! Tu cuenta ha sido cancelada. Esperamos volver a verte pronto."

  # resource should be deleted
  assert_equal final_count, klass.all.count 
end

feature "CanUserDeleteItselfTest" do

  scenario "a logged in user should delete itself" do
    assert_equal 0, User.all.count 
    user = create(:user)
    assert_equal 1, User.all.count 

    login_as(user)
    visit edit_user_registration_path
    page.must_have_content "Darme de baja"

    click_button "Darme de baja"
    page.must_have_content "¡Adiós! Tu cuenta ha sido cancelada. Esperamos volver a verte pronto."
    assert_equal 0, User.all.count 
    assert_equal 1, User.with_deleted.count
    u = User.with_deleted.first
    assert u.deleted_at?
  end

  scenario "a logged in user should delete itself after making a support on a proposal", js: true do
    assert_equal 0, Support.all.count 
    proposal = create(:proposal)
    user = create(:user)

    login_as(user)
    visit proposals_path
    click_button "Apoyar propuesta"
    page.must_have_content "¡Muchas gracias!"
    assert_equal 1, Support.all.count 

    visit edit_user_registration_path
    click_link "Darme de baja" # change tab
    click_button "Darme de baja"
    page.must_have_content "¡Adiós! Tu cuenta ha sido cancelada. Esperamos volver a verte pronto."

    # resource should be deleted
    assert_equal 0, Support.all.count 
  end

  scenario "a logged in user should delete itself after making a collaboration", js: true do
    create_resource_and_delete_itself Collaboration, :collaboration, 0
  end

  scenario "a logged in user should delete itself after making a microcredit", js: true do
    create_resource_and_delete_itself MicrocreditLoan, :microcredit_loan, 1
  end

  scenario "a logged in user should delete itself after making a vote", js: true do
    create_resource_and_delete_itself Vote, :vote, 0
  end
end 
