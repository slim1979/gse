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

    it_behaves_like 'deliver_later', 'will send notification to subscribers'

    def load_params
      @class = NewAnswerMailer
      @method = 'send_notification'
    end

    def action
      Answer.create(user: user2, question: question, body: 'adfsdfsdfasd')
    end
  end
end
