require 'rails_helper'

feature 'Any user can see list of all questions', %q{
  In order to see all questions list
  Any user (guest or authenticated) can
  visit qustions index page with all quesitons
} do

  given!(:questions) { create_list(:question, 10) }

  scenario 'Any user can see list of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

end
