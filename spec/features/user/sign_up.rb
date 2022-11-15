require 'rails_helper'

feature 'Unauthenticated user can sign up', %q{
  In order give answers and ask questions
  As an unregistred user
  I want to be able to sign up
} do
  background { visit new_user_registration_path }

  scenario "Unregistred user tries to sign up" do
    fill_in 'Email', with: 'test_email@test.com'
    fill_in 'Password', with: '123123'
    fill_in 'Password confirmation', with: '123123'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end
