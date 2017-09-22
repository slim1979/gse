module AcceptanceHelper
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

  def expectations
    expect(page).to have_content question3.title
    expect(page).to have_content question3.body
    answers3.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
