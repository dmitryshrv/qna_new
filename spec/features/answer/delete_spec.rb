require 'rails_helper'

feature 'User can delete his answer', %q{
  In order to remove incorrect answer
  As authenticated user
  I can delete my answer to the question
} do
  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { create(:question, user: user_two) }
  given!(:answer_one) { create(:answer, question: question, user: user_one)}
  given!(:answer_two) { create(:answer, question: question, user: user_two)}

  describe 'Authenticated user' do
    background { sign_in(user_one) }

    scenario 'User tries to delete his answer', js:true do
      visit question_path(question)
      click_on 'Delete answer'
      page.accept_alert

      expect(page).not_to have_content answer_one.body
    end

    scenario "User can't see delete button on not his answer" do
      visit question_path(question)
      expect(page).not_to have_link( 'Delete answer', href: answer_path(answer_two) )
    end
  end

  scenario "Unauthenticated user can't see answer delete button" do
    visit question_path(question)
    expect(page).not_to have_content "Delete answer"
  end
end
