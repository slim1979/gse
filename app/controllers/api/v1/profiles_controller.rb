class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :load, :profile
    respond_with current_resource_owner
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end
