require 'rails_helper'

RSpec.describe AttachesController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }
  let(:question_attach) { create(:attach, attachable: question) }
  let(:answer_attach) { create(:attach, attachable: answer) }

  describe 'DELETE #destroy' do
    context 'question attach' do
      context 'as an attachable author' do
        before { sign_in user }
        it 'assigns request attach to @attach' do
          delete :destroy, params: { id: question_attach }, format: :js
          expect(assigns(:attach)).to eq question_attach
        end
        it 'reduce attaches count' do
          question_attach
          expect { delete :destroy, params: { id: question_attach }, format: :js }.to change(question.attaches, :count).by(-1)
        end
        it 'render template destroy' do
          delete :destroy, params: { id: question_attach }, format: :js
          expect(response).to render_template :destroy
        end
      end
      context 'as another attachable author' do
        it 'will not reduce attaches count' do
          sign_in user2
          question_attach
          expect { delete :destroy, params: { id: question_attach }, format: :js }.to_not change(Attach, :count)
        end
      end
      context 'as unauthenticated user' do
        it 'will not reduce attaches count' do
          question_attach
          expect { delete :destroy, params: { id: question_attach }, format: :js }.to_not change(Attach, :count)
        end
      end
    end
  end
end
