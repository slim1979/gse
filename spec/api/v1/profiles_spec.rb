require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'return 401 status if there is no access token' do
        get '/api/v1/profiles/me', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if access token is invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1213131' }
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token) }

      it 'returns status 200' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token }
        expect(response).to be_success
      end
    end
  end
end
