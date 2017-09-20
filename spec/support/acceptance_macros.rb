module AcceptanceMacros
  def casting
    given!(:user)        { create(:user) }
    given!(:user1)       { create(:user) }
    given!(:question3)   { create(:question, user: user1) }
    given!(:answers3)    { create_list(:answer, 5, question: question3, user: user1) }
  end
end
