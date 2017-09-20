FactoryGirl.define do
  sequence :title do |n|
    "Question Title №#{n}"
  end

  sequence :body do
    ('a'..'z').to_a.sample(51).join
  end

  factory :question do
    title
    body
    user
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
  end
end
