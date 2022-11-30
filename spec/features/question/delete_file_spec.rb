require 'rails_helper'

feature 'User can delete attached file', %q{
  As an authenticated user
  I can delete attached files to my qustion
  But I can't delete attached files of other users questions
} do

  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { create(:question, user: user_one) }
  given(:question_two) { create(:question, user: user_two) }

  describe 'Authenticated user' do
    background { sign_in(user_one) }

    scenario 'deletes his question files', js:true do
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
        filename: 'rails_helper.rb'
      )

      visit question_path(question)

      click_on 'Delete file'
      expect(page).to_not have_link "rails_helper.rb"
    end

    scenario "does not see a link to delete another user question files" do
      visit question_path(question_two)
      within ".question" do
        expect(page).to have_no_link 'Delete file'
      end
    end
  end

  scenario "Unauthenticated user can't delete question files", js: true  do
    visit question_path(question)
    expect(page).to have_no_link 'Delete file'
  end
end
