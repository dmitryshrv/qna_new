require 'rails_helper'

feature 'User can delete question', %q{
  As an authenticated user
  I can delete my question
  But I can't delete question of other users
} do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question_one) { create(:question, user: user_one) }
  given(:question_two) { create(:question, user: user_two) }

  describe 'Authenticated user' do
    background { sign_in(user_one) }

    scenario 'User tries to delete his question' do
      visit question_path(question_one)
      click_on 'Delete question'

      expect(page).to have_content 'Question is successfully deleted'
      expect(page).not_to have_content question_one.title
      expect(page).not_to have_content question_one.body
    end

    scenario "User can't see delete button on not his question" do
      visit question_path(question_two)

      expect(page).not_to have_content 'Delete question'
    end
  end

  scenario "Unauthenticated user can't see question delete button" do
    visit questions_path(question_one)
    expect(page).not_to have_content 'Delete question'
  end
end
