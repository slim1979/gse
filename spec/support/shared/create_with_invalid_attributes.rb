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
