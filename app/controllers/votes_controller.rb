class VotesController < ApplicationController

  def any
    subject_type = params[:subject_type]
    subject_id = params[:subject_id]
    votes_value = params[:votes_value].to_i

    @vote = Vote.where(user: current_user, subject_id: subject_id, subject_type: subject_type).first
    if @vote
      @vote.update_value(votes_value)
    else
      @vote = Vote.create(user: current_user, subject_id: subject_id, subject_type: subject_type, value: votes_value)
      @vote.update_subject_votes_count(votes_value)
    end
    respond_to { |format| format.json { render partial: 'votes/votes' } }
  end
end
