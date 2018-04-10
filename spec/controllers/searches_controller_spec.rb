require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  sign_in_user

  describe 'POST #search_hound', js: true do
    it 'will render search_hound template' do
      post :search_hound, params: { search_for: 'ffdfd', search_through: "full_search" }
      expect(response).to render_template :search_hound
    end

    it 'will render search_hound template' do
      expect(Search).to receive(:make_search)
      post :search_hound, params: { search_for: 'ffdfd', search_through: "full_search" }
    end
  end
end
