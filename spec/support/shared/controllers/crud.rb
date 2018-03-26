def assign_attributes
  load_params
  @object = @shared_params[:object]
  @attributes = @shared_params[:attributes]
  @render = @shared_params[:render] if @shared_params[:render]
end

def attributes_not_changed
  current_value
  @object.reload
  @attributes.each do |attrib|
    expect(@object.send(attrib.to_s)).to_not eq nil
    expect(@object.send(attrib.to_s)).to eq @current_values[attrib.to_s]
  end
end

def current_value
  @current_values = {}
  @attributes.each do |attrib|
    @current_values[attrib] = @object.send(attrib.to_s)
  end
  @current_values
end

RSpec.shared_examples 'POST #create' do |param|
  before { assign_attributes }

  context 'with valid attributes' do
    before { valid_post_create }

    it "saves new #{param} to DB" do
      expect { valid_post_create }.to change(@object, :count).by(1)
    end

    it 'will return status 200 OK' do
      expect(response).to be_success
    end

    it 'will render create template create' do
      expect(response).to render_template :create
    end
  end

  context 'with invalid attributes' do
    before { invalid_post_create }

    it "does not save the new #{param} to DB" do
      expect { invalid_post_create }.to_not change(@object, :count)
    end

    it 'renders template create' do
      expect(response).to render_template :create
    end
  end
end

RSpec.shared_examples 'PATCH #update' do |param|
  before { assign_attributes }

  describe 'by author' do
    context 'valid attributes' do
      before { valid_patch_update }

      it "assigns request #{param} to @#{param}" do
        expect(assigns(@object.class.name.downcase.to_sym)).to eq @object
      end

      it 'will have status 200 OK' do
        @object.reload
        expect(response.status).to eq 200
      end

      it "change #{param} attributes" do
        @object.reload
        @attributes.each do |attrib|
          expect(@object.send("#{attrib}")).to eq "new #{attrib}"
        end
      end
    end

    context 'invalid attributes' do
      before { invalid_patch_update }

      it "does not change #{param} attributes" do
        attributes_not_changed
      end

      it 're-render edit template update' do
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

RSpec.shared_examples 'DELETE #destroys' do |param|
  before { assign_attributes }
  describe 'Object by author' do
    it "will decrease #{param} count" do
      expect { delete_destroy }.to change(@object.class, :count).by(-1)
    end

    it 'redirect to destroy view' do
      delete :destroy, params: { id: @object }, format: :js
      expect(response).to render_template :destroy
    end
  end

  context "#{param} by other author" do
    it "will not decrease #{param}s count" do
      sign_in user2
      expect { delete :destroy, params: { id: @object }, format: :js }.to_not change(@object.class, :count)
    end
  end

  context 'object by unauthenticated user' do
    it "will not decrease #{param}s count" do
      sign_out @user
      expect { delete :destroy, params: { id: @object }, format: :js }.to_not change(@object.class, :count)
    end

    it "will redirect to log in page" do
      sign_out @user
      delete :destroy, params: { id: @object }
      expect(response).to redirect_to new_user_session_path
    end
  end
end
