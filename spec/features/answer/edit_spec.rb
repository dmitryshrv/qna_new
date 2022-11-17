require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of the answer
  I'd like to be able to edit my answer
} do
  given!(:user) {create(:user)}
  given(:user_other) {create(:user)}
  given!(:question) {create(:question)}
  given!(:answer) {create(:answer, question: question, user: user)}
  given!(:answer_other) {create(:answer, question: question, user: user_other)}

  scenario "Unauthenticated user can not edit the answer" do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user" do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "edits his answer", js:true do
      click_on "Edit"

      within ".answers" do
        fill_in 'Body', with: "edited answer"
        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to have_content "edited answer"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "edits his answer with errors", js:true do
      click_on "Edit"

      within ".answers" do
        fill_in 'Body', with: ""
        click_on "Save"

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector "textarea"
      end
    end

    scenario "tries to edit other user's answer" do
      within "#answer-#{answer_other.id}" do
        expect(page).to_not have_link('Edit')
      end
    end

  end
end
