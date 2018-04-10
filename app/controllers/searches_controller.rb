class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_hound
    authorize! :search, :content
    search_for = params[:search_for]
    search_through = params[:search_through]
    search_through ||= :full_search
    @result = Search.make_search(search_for, search_through)
  end
end
