require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token }
      end
      it 'returns status 200' do
        expect(response.status).to eq 200
      end

      %w[id email created_at updated_at admin].each do |kind|
        it "contain #{kind}" do
          expect(response.body).to be_json_eql(me.send(kind.to_sym).to_json).at_path(kind)
        end
      end

      %w[password encrypted_password].each do |kind|
        it "does not contain #{kind}" do
          expect(response.body).to_not have_json_path(kind)
        end
      end
    end
  end

  describe 'GET index' do
    context 'authorized' do
      let!(:users) { create_list(:user, 5) }
      let(:access_token) { create(:access_token, resource_owner_id: users[0].id) }

      before do
        get '/api/v1/profiles', params: { format: :json, access_token: access_token.token }
      end

      it 'return status 200' do
        expect(response).to be_success
      end

      it 'contain users list, except current user' do
        expect(response.body).to be_json_eql(users[1..4].to_json).at_path('/')
      end
    end
  end

  describe 'unauthorized' do
    %w[/me /].each do |path|
      it "return 401 status if there is no access token on #{path}" do
        get "/api/v1/profiles#{path}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it "return 401 status if access token is invalid on #{path}" do
        get "/api/v1/profiles#{path}", params: { format: :json, access_token: '1213131' }
        expect(response.status).to eq 401
      end
    end
  end
end
