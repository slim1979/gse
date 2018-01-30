class AuthorizationsController < ApplicationController
  def confirm_email
    @id = params[:id]
  end
end
