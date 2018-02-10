require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  %w[Facebook Twitter].each do |network|
    describe "GET ##{network.downcase}" do
      before do
        @network_to_sym = network.downcase.to_sym
        OmniAuth.config.mock_auth.each_key{ |provider| OmniAuth.config.mock_auth.delete(provider) }
        OmniAuth.config.mock_auth[@network_to_sym] = OmniAuth::AuthHash.new({
          provider: "#{network.downcase}",
          uid: '123545',
          info: { name: 'Some Name' }
        })
        request.env['devise.mapping'] = Devise.mappings[:user]
        session['devise.omniauth_data'] = request.env['omniauth.auth'] = OmniAuth.config.mock_auth[@network_to_sym]
      end

      it "should render template get_email when #{network} doesn\'t return email" do
        get @network_to_sym
        expect(response).to render_template :get_email
      end

      it "should render template send_confirmation_email when #{network} return an email" do
        OmniAuth.config.mock_auth[@network_to_sym]['info']['email'] = 'some@email.com'
        get @network_to_sym
        expect(response).to render_template :send_confirmation_email
        OmniAuth.config.mock_auth[@network_to_sym]['info'].delete('email')
      end
    end
  end
end
