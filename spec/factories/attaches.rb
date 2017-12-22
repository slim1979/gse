FactoryBot.define do
  factory :attach do
    file { fixture_file_upload("#{Rails.root}/spec/acceptance/questions/create_question_spec.rb")}
  end
end
