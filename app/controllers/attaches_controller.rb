class AttachesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attach

  authorize_resource

  def destroy
    @attach.destroy
  end

  private

  def load_attach
    @attach = Attach.find(params[:id])
  end
end
