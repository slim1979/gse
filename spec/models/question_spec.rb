require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attaches }
  it { should accept_nested_attributes_for :attaches }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many :votes }

  describe 'after create' do
    let(:user) { create(:user) }

    it 'should create an subscription' do
      question = Question.create(title: 'dsdsd', body: 'dasd0', user: user)
      expect(Subscription.where(question: question, user: user).count).to eq 1
    end

    it 'should send an thanks email' do
      expect(ThanksMailer).to receive(:send_thanks).and_call_original
      Question.create(title: 'dsdsd', body: 'dasd0', user: user)
    end
  end

end
