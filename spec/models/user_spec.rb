require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  # . if class method, # if instance method
  describe 'oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345') }

    context '.find_for_oauth' do
      context 'user already has authorization' do
        it 'returns the user' do
          user.authorizations.create(provider: 'facebook', uid: '12345', email: user.email)
          expect(User.find_for_oauth(auth, nil)).to eq user
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
      end
    end

    context '.both_user_and_authorization_create' do
      context 'there is no user and no authorization yet' do
        before { @email = 'some@test.vv' }
        it 'will show the number of users is 0' do
          expect(User.where(email: @email).count).to eq 0
        end
        it 'will create a new user' do
          expect { User.both_user_and_authorization_create(auth, @email) }.to change(User, :count).by(1)
        end
        it ' and authorization for him' do
          User.both_user_and_authorization_create(auth, @email)
          user = User.last
          expect(user.authorizations.first.provider).to eq 'facebook'
          expect(user.authorizations.first.uid).to eq '12345'
        end
      end
    end
  end
end
