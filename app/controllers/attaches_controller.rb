class AttachesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attach

  respond_to :json

  def destroy
    @attach.destroy if current_user.author_of?(@attach.attachable)
    respond_with @attach
  end

  private

  def load_attach
    @attach = Attach.find(params[:id])
  end
end
