require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :subject }
  it { should validate_presence_of :user }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :value }
  it { should validate_uniqueness_of(:user_id).scoped_to(:subject_id, :subject_type) }
end
