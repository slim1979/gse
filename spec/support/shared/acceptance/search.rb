RSpec.shared_examples 'search through' do |params|
  it "search through #{params}" do
    choose("search_through_#{params}")
    click_on 'Искать'

    load_params.each do |object|
      expect(page).to have_content "#{object.class == Question ? object.title : object.body}"
    end
  end
end
