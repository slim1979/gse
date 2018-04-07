require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:question_owner) { create(:user) }
  let(:answer_owner)   { create(:user) }
  let(:subscribers)    { create_list(:user, 3) }
  let(:question)       { create(:question, user: question_owner) }
  let(:answer)         { create(:answer, question: question, user: answer_owner) }

  it 'all subscribers will receive notification' do
    subscribers.each { |subscriber| subscriber.subscriptions.create(question: question) }
    question.subscriptions.each do |subscription|
      expect(NewAnswerMailer).to receive(:send_notification).with(subscription.user, question, answer).and_call_original
    end
    NewAnswerJob.perform_now(answer)
  end
end
