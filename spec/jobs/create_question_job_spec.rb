require 'rails_helper'

RSpec.describe CreateQuestionJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  it 'will create subscription' do
    expect{ CreateQuestionJob.perform_now(user, question) }.to change(user.subscriptions, :count).by(1)
  end

  it 'will send an email' do
    expect(ThanksMailer).to receive(:send_thanks).with(user, question).and_call_original
    CreateQuestionJob.perform_now(user, question)
  end
end
