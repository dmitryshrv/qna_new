require 'rails_helper'

feature 'User can answer the question', %q{
  In order to help community
  As an authenticated user
  I can give answer to question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'give an answer' do
      fill_in 'Body', with: 'Test Answer body'
      click_on 'Answer'

      expect(page).to have_content 'Your answer was successfully created.'
      expect(page).to have_content 'Test Answer body'
    end

    scenario 'give an answer with error' do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to asks a question' do
    visit question_path(question)
    click_on 'Answer'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
