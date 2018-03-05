require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  describe 'Facebook' do
    it_behaves_like 'Omniauthenticable', 'Facebook'
  end

  describe 'Twitter' do
    it_behaves_like 'Omniauthenticable', 'Twitter'
  end
end
