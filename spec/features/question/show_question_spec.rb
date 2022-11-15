require 'rails_helper'

feature 'Any user can read question with answers', %q{
  In order see answers to the question
  Any user (guest or authenticated) can
  visit qustions page and see all answers to
  question on the same page
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question)}

  scenario 'Any user read all answers on question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
       expect(page).to have_content answer.body
    end
  end

end
