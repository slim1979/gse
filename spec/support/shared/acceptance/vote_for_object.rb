require 'acceptance_helper'

RSpec.shared_examples 'Vote for' do |param|
  before { load_params }

  scenario "vote for the #{param} - like - for the first time", js: true do
    within ".#{param}" do
      like
      within ".#{param}_votes_count_#{@shared_params[:object].id}" do
        expect(page).to have_content @votes_count + 1
      end
    end
  end

  scenario "vote for the #{param} - dislike - for the first time", js: true do
    within ".#{param}" do
      dislike
      within ".#{param}_votes_count_#{@shared_params[:object].id}" do
        expect(page).to have_content @votes_count - 1
      end
    end
  end

  scenario "vote for the #{param} - like - the second and subsequent times, by same user will not increase the #{param} rating", js: true do
    within ".#{param}" do
      3.times { like }
      within ".#{param}_votes_count_#{@shared_params[:object].id}" do
        expect(page).to have_content 1
      end
    end
  end

  scenario "vote for the #{param} - dislike - the second and subsequent times will not decrease the #{param} rating", js: true do
    within ".#{param}" do
      3.times { dislike }
      within ".#{param}_votes_count_#{@shared_params[:object].id}" do
        expect(page).to have_content(-1)
      end
    end
  end
end
