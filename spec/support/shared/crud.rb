shared_examples 'Create with valid attributes' do
  before do
    load_params
    valid_post_create
  end

  it 'saves new question to DB' do
    expect { valid_post_create }.to change(@shared_params[:object], :count).by(1)
  end

  it 'will return status 200 OK' do
    expect(response).to be_success
  end

  it 'will render create template' do
    expect(response).to render_template @shared_params[:render]
  end
end

shared_examples 'Update by author' do
  before { load_params }

  context 'valid attributes' do
    before { valid_patch_update }

    it 'assigns request question to @question' do
      expect(assigns(@shared_params[:object].class.name.downcase.to_sym)).to eq @shared_params[:object]
    end

    it 'will have status 200 OK' do
      @shared_params[:object].reload
      expect(response.status).to eq 200
    end

    it 'change question attributes' do
      @shared_params[:object].reload
      @shared_params[:attributes].each do |attrib|
        expect(@shared_params[:object].send("#{attrib}")).to eq "new #{attrib}"
      end
    end
  end

  context 'invalid attributes' do
    before { valid_patch_update }

    it 'does not change question attributes' do
      @shared_params[:object].reload
      @shared_params[:attributes].each do |attrib|
        expect(@shared_params[:object].send(attrib.to_s)).to_not eq nil
        expect(@shared_params[:object].send(attrib.to_s)).to eq @shared_params[:object].send("#{attrib}")
      end
    end

    it 're-render edit template' do
      expect(response).to render_template 'update'
    end
  end
end

shared_examples 'Create with invalid attributes' do
  before do
    load_params
    invalid_post_create
  end

  it 'does not save the new question to DB' do
    expect { invalid_post_create }.to_not change(@shared_params[:object], :count)
  end

  it 'renders template' do
    expect(response).to render_template @shared_params[:render]
  end
end
