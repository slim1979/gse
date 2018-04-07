require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many :attaches }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attaches }
  it { should have_many :votes }

  describe 'on create' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:question) { create(:question) }
    let(:subscription) { create(:subscription, user: user, question: question) }

    it 'will send notification to subscribers' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(NewAnswerMailer).to receive(:send_notification).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      Answer.create(user: user2, question: question, body: 'adfsdfsdfasd')
    end
  end
end
