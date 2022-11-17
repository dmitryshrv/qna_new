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

    scenario 'give an answer', js:true do
      fill_in 'Body', with: 'Test Answer body'
      click_on 'Give answer'

      expect(page).to have_content 'Test Answer body'
    end

    scenario 'give an answer with error', js:true do
      click_on 'Give answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to give an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Give answer'
  end
end
