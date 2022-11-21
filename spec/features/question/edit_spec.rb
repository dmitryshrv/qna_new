require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of the question
  I'd like to be able to edit my qustion
} do
  given!(:user) {create(:user)}
  given(:user_other) {create(:user)}
  given!(:question) {create(:question, user:user)}
  given!(:question_other) {create(:question, user:user_other)}


  scenario "Unauthenticated user can not edit the question" do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user" do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "edits his question", js:true do
      within ".question" do
        click_link "Edit"
        fill_in 'Title', with: "edited title"
        fill_in 'Body', with: "edited body"
        click_on "Save"

        expect(page).to_not have_content question.title
        expect(page).to have_content "edited title"

        expect(page).to_not have_content question.body
        expect(page).to have_content "edited body"
        expect(page).to_not have_selector "textarea"
      end
    end

    scenario "edits his question with errors", js:true do
      click_on "Edit"

      within ".question" do
        fill_in 'Body', with: ""
        click_on "Save"

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector "textarea"
      end
    end

    scenario 'edits his question with attached files', js:true do
      within '.question' do
        click_link 'Edit'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
      end

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario "tries to edit other user's question" do
      visit question_path(question_other)

      within ".question" do
        expect(page).to_not have_link('Edit')
      end
    end

  end
end
