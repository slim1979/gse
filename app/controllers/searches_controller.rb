class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search_hound
    authorize! :search, :content
    search_for = params[:search_for]
<<<<<<< f0746ffb1e9ff90092e2daa888a84e1f07452508
    search_through = params[:search_through]
    search_through ||= :full_search
    @result = Search.make_search(search_for, search_through)
=======
    search_through = params[:search_through].to_sym
    # debugger
    @result = Search.new.make_search(search_for, search_through)
>>>>>>> search_hound method added
  end
end
