require 'rails_helper'

RSpec.describe AttachesController, type: :controller do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:question_attach) { create(:attach, attachable: question) }
  let(:answer_attach) { create(:attach, attachable: answer) }

  describe 'DELETE #destroy' do
    context 'question attach' do
      it_behaves_like 'attaches DELETE #destroy'

      def do_request
        delete :destroy, params: { id: question_attach }, format: :json
      end

      def load_params
        @shared_params = { object: question, object_attach: question_attach }
      end
    end
    context 'answer attach' do
      it_behaves_like 'attaches DELETE #destroy'

      def do_request
        delete :destroy, params: { id: answer_attach }, format: :json
      end

      def load_params
        @shared_params = { object: answer, object_attach: answer_attach }
      end
    end
  end
end
