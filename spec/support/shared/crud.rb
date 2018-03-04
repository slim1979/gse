def assign_attributes
  load_params
  @object = @shared_params[:object]
  @attributes = @shared_params[:attributes]
  @render = @shared_params[:render] if @shared_params[:render]
end

def attributes_not_changed
  @object.reload
  @attributes.each do |attrib|
    expect(@object.send(attrib.to_s)).to_not eq nil
    expect(@object.send(attrib.to_s)).to eq @object.send("#{attrib}")
  end
end

shared_examples 'POST #create' do
  context 'with valid attributes' do
    before do
      assign_attributes
      valid_post_create
    end

    it 'saves new question to DB' do
      expect { valid_post_create }.to change(@object, :count).by(1)
    end

    it 'will return status 200 OK' do
      expect(response).to be_success
    end

    it "will render create template #{@render}" do
      expect(response).to render_template @render
    end
  end

  context 'with invalid attributes' do
    before do
      assign_attributes
      invalid_post_create
    end

    it 'does not save the new question to DB' do
      expect { invalid_post_create }.to_not change(@object, :count)
    end

    it 'renders template create' do
      expect(response).to render_template :create
    end
  end
end

shared_examples 'PATCH #update' do
  before { assign_attributes }
  describe 'by author' do
    context 'valid attributes' do
      before { valid_patch_update }

      it 'assigns request question to @question' do
        expect(assigns(@object.class.name.downcase.to_sym)).to eq @object
      end

      it 'will have status 200 OK' do
        @object.reload
        expect(response.status).to eq 200
      end

      it 'change question attributes' do
        @object.reload
        @attributes.each do |attrib|
          expect(@object.send("#{attrib}")).to eq "new #{attrib}"
        end
      end
    end

    context 'invalid attributes' do
      before { valid_patch_update }

      it 'does not change question attributes' do
        attributes_not_changed
      end

      it 're-render edit template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'by authenticated someone else' do
    it 'will not change attributes' do
      sign_out @user
      sign_in user2
      valid_patch_update
      attributes_not_changed
    end
  end
end
