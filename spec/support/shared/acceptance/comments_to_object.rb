require 'acceptance_helper'

RSpec.shared_examples 'Comments for' do |param|
  before do
    sign_in other_user
    visit question_path(question)
  end

  scenario "user sees link to leave a comment to #{param}" do
    within ".#{param}" do
      expect(page).to have_link 'Комментировать'
    end
  end

  scenario "user leaves a comment #{param}" do

    within ".#{param}" do
      click_on 'Комментировать'
    end
    # form for new comment is raising
    expect(page).to have_css 'form.new_comment'
    # creating comment
    fill_in 'Body', with: 'New comment'
    click_on 'Create Comment'
    # form is hiding
    expect(page).to_not have_css 'form.new_comment'
    # new comment is now showed in .comments
    within ".#{param}>.comments" do
      expect(page).to have_content 'New comment'
    end
  end

end
