require 'rails_helper'

feature 'Authenticated user can sign out', %q{
  To end the session
  As an authenticated user
  I can sign out
} do
  given(:user) { create(:user) }
  background {sign_in(user)}

  scenario "Authenticated user signs out" do
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

end
