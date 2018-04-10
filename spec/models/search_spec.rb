require 'rails_helper'

RSpec.describe Search, type: :model do
  it 'execute full search' do
    expect(ThinkingSphinx).to receive(:search).with('request')
    Search.make_search('request', :full_search)
  end

  ['questions', 'answers', 'comments', 'users'].each do |klass|
    it "finds model in #{klass}" do
      expect(klass.chop.capitalize.constantize).to receive(:search).with('request')
      Search.make_search('request', klass.to_sym)
    end
  end
end
