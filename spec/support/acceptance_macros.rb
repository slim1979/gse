module AcceptanceMacros
  def fullfill_with_content
    given!(:user)        { create(:user) }
    given!(:user1)       { create(:user) }
    given!(:user2)       { create(:user) }
    given!(:user3)       { create(:user) }
    given!(:question1)   { create(:question, user: user3) }
    given!(:answers1)    { create_list(:answer, 5, question: question1, user: user3) }
    given!(:question2)   { create(:question, user: user2) }
    given!(:answers2)    { create_list(:answer, 5, question: question2, user: user2) }
    given!(:question3)   { create(:question, user: user1) }
    given!(:answers3)    { create_list(:answer, 5, question: question3, user: user1) }
  end
end
