class AttachesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attach

  def destroy
    @attach.destroy if current_user.author_of?(@attach.attachable)
  end

  private

  def load_attach
    @attach = Attach.find(params[:id])
  end
end
