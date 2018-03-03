shared_examples 'Unauthorized' do
  it 'return 401 status if there is no access token' do
    do_request
    expect(response.status).to eq 401
  end

  it 'return 401 status if access token is invalid' do
    do_request(access_token: '12345')
    expect(response.status).to eq 401
  end
end
