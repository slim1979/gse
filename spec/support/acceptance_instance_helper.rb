module AcceptanceInstanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Log in'
  end

  def reaching_the_questions_list
    questions
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
