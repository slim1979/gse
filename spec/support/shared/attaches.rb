shared_examples 'attaches DELETE #destroy' do
  before { load_params }

  context 'as an attachable author' do
    before { sign_in user }
    it 'assigns request attach to @attach' do
      do_request
      expect(assigns(:attach)).to eq @shared_params[:object_attach]
    end
    it 'reduce attaches count' do
      @shared_params[:object_attach]
      expect { do_request }.to change(@shared_params[:object].attaches, :count).by(-1)
    end
  end

  context 'as another attachable author' do
    it 'will not reduce attaches count' do
      sign_in user2
      @shared_params[:object_attach]
      expect { do_request }.to_not change(@shared_params[:object].class, :count)
    end
  end

  context 'as unauthenticated user' do
    it 'will not reduce attaches count' do
      @shared_params[:object_attach]
      expect { do_request }.to_not change(@shared_params[:object].class, :count)
    end
  end
end
