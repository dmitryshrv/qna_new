require 'rails_helper.rb'

feature 'User can add links to answer' , %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given(:question) { create(:question) }
  given(:gist_url) {"https://gist.github.com/bl1ndy/bd47333aa281ff7d6f160abe3650db5e"}

  scenario 'User adds link when gives answer', js:true do
    sign_in user
    visit question_path(question)

    fill_in 'Body', with: 'Test Answer body'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Give answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
