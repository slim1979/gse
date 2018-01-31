require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  # . if class method, # if instance method
  describe 'oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345')}

    context '.find_for_oauth' do
      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '12345')
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context '#first_or_create_authorization' do
      context 'user already exist, but has no authorizations yet' do
        it 'check, that user has no authorizations yet' do
          expect(user.authorizations.count).to eq 0
        end
        it 'will create a new authorization' do
          expect { user.first_or_create_authorization(auth) }.to change(user.authorizations, :count).by(1)
        end
      end
      context 'user already exist and has an authorization' do

        before { user.authorizations.create(provider: 'facebook', uid: '12345') }

        it 'will check for exists authorization' do
          expect(user.authorizations.count).to eq 1
        end
        it 'will not create new authorization' do
          expect { user.first_or_create_authorization(auth) }.to_not change(Authorization, :count)
        end
        it 'will form letter and will put it in queue' do
          user.first_or_create_authorization(auth)
          last_email = ActionMailer::Base.deliveries.last
          expect(last_email.to).to eq ["#{user.email}"]
        end
      end
    end
  end

  # context 'user has no authorization' do
  #   context 'user already exists' do
  #     it 'does not create user' do
  #       email = user.email
  #       user = User.where(email: email).first
  #       expect { user.first_or_create_authorization(auth) }.to_not change(User, :count)
  #     end
  #     it 'creates authorization for user' do
  #       expect { user.first_or_create_authorization(auth) }.to change(user.authorizations, :count).by(1)
  #     end
  #     it 'creates authorization with provider and uid' do
  #       user.first_or_create_authorization(auth)
  #       authorization = user.authorizations.first
  #
  #       expect(authorization.provider).to eq auth.provider
  #       expect(authorization.uid).to eq auth.uid
  #     end
  #   end
  # end
end
