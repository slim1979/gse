module VotesActions
  def vote(user, votes_value)
    @current_user_vote = votes.where(user: user).first
    if @current_user_vote
      check_and_update(votes_value)
    else
      votes.create(user: user, value: votes_value)
      update!(votes_count: self.votes_count + votes_value)
    end
  end

  def check_and_update(votes_value)
    value = @current_user_vote.value
    unless value == votes_value
      @current_user_vote.update!(value: value + votes_value)
      update!(votes_count: self.votes_count + votes_value)
    end
  end
end
