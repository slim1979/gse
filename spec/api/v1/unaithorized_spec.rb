require 'rails_helper'

describe 'Unauthorized' do
  %w[profiles/ profiles/me questions/ questions/show].each do |path|
    it "return 401 status if there is no access token on api/v1/#{path}" do
      get "/api/v1/#{path}", params: { format: :json }
      expect(response.status).to eq 401
    end

    it "return 401 status if access token is invalid on api/v1/#{path}" do
      get "/api/v1/#{path}", params: { format: :json, access_token: '1213131' }
      expect(response.status).to eq 401
    end
  end
end
