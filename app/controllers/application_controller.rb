require 'application_responder'

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  # respond_to :html

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  check_authorization unless: :devise_controller?
end
