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

RSpec.shared_examples 'Cannot vote for' do |param|

  scenario "tries to vote for #{param}" do
    visit question_path(question)

    expect(page).to_not have_selector '.like'
    expect(page).to_not have_selector '.dislike'
  end
end

RSpec.shared_examples 'Muliusers votes for' do |param|
  before { load_params }

  scenario "The multi-user voting pressuresa in the ranking of #{param}", js: true do
    sign_in some_other_user
    visit question_path(question)
    within ".#{param}" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user2
    visit question_path(question)
    within ".#{param}" do
      click_on 'like'
    end
    sign_out

    sign_in some_other_user3
    visit question_path(question)
    within ".#{param}" do
      click_on 'dislike'
    end
    sign_out

    visit question_path(question)

    within ".#{param}_votes_count_#{@shared_params[:object].id}" do
      expect(page).to have_content 1
    end
  end
end

RSpec.shared_examples 'Can cancel vote for' do |param|
  before do
    sign_in other_user
    visit question_path(question)
    load_params
    @object = @shared_params[:object]
    @current_votes_count = @object.votes_count
    expect(@current_votes_count).to eq 0
  end

  scenario "Can cancel vote for #{param}", js: true do
    within ".#{param}_vote_box" do
      click_on 'like'
    end

    within ".#{param}_votes_count_#{@object.id}" do
      expect(page).to have_content @current_votes_count + 1
      @object.reload
      expect(@object.votes_count).to eq 1
    end

    within ".#{param}_vote_box" do
      click_on 'dislike'
    end

    within ".#{param}_votes_count_#{@object.id}" do
      expect(page).to have_content @current_votes_count
    end

    within ".#{param}_vote_box" do
      click_on 'dislike'
    end

    within ".#{param}_votes_count_#{@object.id}" do
      expect(page).to have_content @current_votes_count - 1
    end

    within ".#{param}_vote_box" do
      click_on 'like'
    end

    within ".#{param}_votes_count_#{@object.id}" do
      expect(page).to have_content @current_votes_count
    end
  end
end
