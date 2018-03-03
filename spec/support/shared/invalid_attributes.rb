shared_examples 'Create with invalid attributes' do
  before { load_params }

  it 'does not save the new question to DB' do
    expect { @request_params[:request] }.to_not change(@request_params[:object], :count)
  end

  it 'renders template' do
    @request_params[:request]
    expect(response).to render_template @request_params[:render]
  end
end
