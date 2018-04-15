class SearchesController < ApplicationController
  # before_action :authenticate_user!
  skip_authorization_check

  def search_hound
    # authorize! :search, :content
    search_for = params[:search_for]
    search_through = params[:search_through]
    search_through ||= :full_search
    @result = Search.make_search(search_for, search_through)
  end

  def show
    redirect_to root_path
  end
end
