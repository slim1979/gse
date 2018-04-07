require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:questions) { create_list(:question, 5, created_at: 1.days.ago) }

  it 'will send daily digest to all users' do
    User.pluck(:email).each do |email|
      expect(DailyMailer).to receive(:digest).with(email, questions.to_a).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
