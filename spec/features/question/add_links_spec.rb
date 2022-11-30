require 'rails_helper.rb'

feature 'User can add links to qustions' , %q{
  In order to provide additional info to my question
  An an question's author
  I'd like to be able to add links
} do

  given(:user) {create(:user)}
  given(:gist_url) {"https://gist.github.com/bl1ndy/bd47333aa281ff7d6f160abe3650db5e"}

  scenario 'User adds link when asks question' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
  end
end
