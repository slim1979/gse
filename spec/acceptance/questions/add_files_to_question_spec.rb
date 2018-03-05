require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an questions author
  I want to be able to attach files
} do

  given(:user) { create(:user) }

  it_behaves_like 'Add files', 'question'
end
