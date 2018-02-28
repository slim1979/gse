require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:question) { create :question, user: user }
    let(:answer) { create :answer, question: question, user: user }
    let(:own_answer_on_other_question) { create :answer, question: other_question, user: user }
    let(:comment) { create :comment, commented: question, user: user }
    let(:attach) { create :attach, attachable: answer }
    let(:other) { create :user }
    let(:other_question) { create :question, user: other }
    let(:other_answer) { create :answer, question: other_question, user: other }
    let(:other_comment) { create :comment, commented: other_question, user: other }
    let(:other_attach) { create :attach, attachable: other_answer }

    it { should be_able_to :read, :all }
    it { should be_able_to :assign_best, answer }
    it { should be_able_to :manage, attach }
    it { should be_able_to :vote, other_question }
    it { should be_able_to :vote, other_answer }
    it { should be_able_to :load, :profile }
    it { should be_able_to :load, :users_list }

    it { should_not be_able_to :vote, question }
    it { should_not be_able_to :vote, answer }
    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :assign_best, own_answer_on_other_question }
    it { should_not be_able_to :assign_best, other_answer }
    it { should_not be_able_to :vote, answer }
    it { should_not be_able_to :vote, question }
    it { should_not be_able_to :manage, other_attach }

    [Question, Answer, Comment].each do |klass|
      context klass do
        it { should be_able_to :create, klass }

        it { should be_able_to :update, send(klass.name.underscore), user: user }
        it { should_not be_able_to :update, send("other_#{klass.name.downcase}"), user: user }

        it { should be_able_to :destroy, send(klass.name.underscore), user: user }
        it { should_not be_able_to :destroy, send("other_#{klass.name.downcase}"), user: user }
      end
    end
  end
end
