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
