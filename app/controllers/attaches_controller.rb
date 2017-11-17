class AttachesController < ApplicationController
  before_action :authenticate_user!
  def destroy
    @attach = Attach.find(params[:id])
    @attach.destroy if current_user.author_of?(@attach.attachable)

    respond_to do |format|
      format.json { render json: @attach }
    end
  end
end
