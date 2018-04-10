require 'acceptance_helper'

feature 'Search through site', %q{
  In order to find needed content
  As an authenticated user
  I want to be able search by my conditions
} do

  let!(:user)       { create(:user, email: 'www@www.ru', password: 'qwerty', password_confirmation: 'qwerty') }
  let!(:users)      { create_list(:user, 6) }
  let!(:questions)  { create_list(:question, 5, user: users.sample, title: "#{('a'..'z').to_a.sample(51).join} qwerty") }
  let!(:answers)    { create_list(:answer, 5, user: users.sample, body: "#{('a'..'z').to_a.sample(51).join} qwerty answer") }
  let!(:comments)   { create_list(:comment, 5, commented: questions.sample, user: users.sample, body: "#{('a'..'z').to_a.sample(51).join} qwerty question_comment") }

  describe 'Search by content, except users', js: true do
    before do
      ThinkingSphinx::Test.index
      sign_in users.last
      visit root_path
      fill_in :search_for, with: 'qwerty'
    end

    it 'through all content' do
      choose('search_through_full_search')
      click_on 'Искать'

      [questions, answers, comments].each do |objects|
        objects.each do |object|
          expect(page).to have_content "#{object.class == User ? object.email : object.class == Question ? object.title : object.body}"
        end
      end
    end
    describe 'questions' do
      it_behaves_like 'search through', 'questions'

      def load_params
        questions
      end
    end
    describe 'answers' do
      it_behaves_like 'search through', 'answers'

      def load_params
        answers
      end
    end
    describe 'comments' do
      it_behaves_like 'search through', 'comments'

      def load_params
        comments
      end
    end
  end

  describe 'Search through users', js: true do
    it 'will return users' do
      ThinkingSphinx::Test.index
      sign_in users.last
      visit root_path
      fill_in :search_for, with: users.first.email
      choose('search_through_users')
      click_on 'Искать'
      expect(page).to have_content users.first.email
    end
  end
end
