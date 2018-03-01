class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :load, :profile
    respond_with current_resource_owner
  end

  def index
    authorize! :load, :users_list
    respond_with(@users = User.where.not(id: current_resource_owner.id))
  end
end
