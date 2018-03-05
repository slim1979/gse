RSpec.shared_examples 'votes' do |params|
  before { load_params }

  it "vote \'like\' for #{params} will increase its rating" do
    expect {
      send("vote_like_for_#{params}")
      @shared_params[:object].reload
    }.to change(@shared_params[:object], :votes_count).by(1)
  end

  it "vote \'dislike\' for #{params} will decrease its rating" do
    expect {
      send("vote_dislike_for_#{params}")
      @shared_params[:object].reload
    }.to change(@shared_params[:object], :votes_count).by(-1)
  end
end
