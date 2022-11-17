require 'rails_helper'

feature 'User can mark answer as best', %q{
  In order to choose most relevant answer
  As an question's author
  I can mark answer as best answer
}, js:true do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:user) }
  given!(:another_answer) { create(:answer, question:, user:user) }

  describe "Question's author" do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Mark answer as best' do
      within "#answer-#{answer.id}" do
        click_on 'Make best'

        expect(page).to have_content "Best Answer:"
      end
    end

    scenario "doesn't see 'Make Best' button on makred answer" do

      within "#answer-#{answer.id}" do
        click_on 'Make best'

        expect(page).to have_no_button "Make best"
      end
    end

  end

  describe "Not question's author" do

    scenario "can't mark answer as best" do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).to have_no_button('Best')
      end
    end

  end

end
