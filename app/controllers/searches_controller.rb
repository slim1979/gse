class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_hound
    authorize! :search, :content
    search_for = params[:search_for]
    search_through = params[:search_through].to_sym
    @result = Search.new.make_search(search_for, search_through)
  end
end
