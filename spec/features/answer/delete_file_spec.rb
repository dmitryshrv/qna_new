require 'rails_helper'

feature 'User can delete attached file', %q{
  As an authenticated user
  I can delete attached files to his answer
  But I can't delete attached files of other users answers
} do

  given(:user_one) { create(:user) }
  given(:user_two) { create(:user) }
  given(:question) { create(:question, user: user_one) }
  given!(:answer) { create(:answer, user: user_one, question: question) }
  given!(:answer_two) { create(:answer, user: user_two, question: question) }

  background do
    answer.files.attach(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb'
    )
  end

  describe 'Authenticated user' do
    background { sign_in(user_one) }

    scenario 'deletes his answer files', js:true do
      visit question_path(question)

      click_on 'Delete file'
      expect(page).to_not have_content answer.files.first.filename.to_s
    end

    scenario "does not see a link to delete another user answer files", js:true do
      visit question_path(question)
      within "#answer-#{answer_two.id}" do
        expect(page).to_not have_content 'Delete file'
      end
    end
  end

  scenario "Unauthenticated user can't delete answer files", js: true  do
    visit question_path(question)
    expect(page).to have_no_link 'Delete file'
  end
end
