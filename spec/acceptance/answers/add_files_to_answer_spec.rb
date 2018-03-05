require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answers author
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  it_behaves_like 'Add files', 'answer'
end
