require 'rails_helper'

Sidekiq::Testing.inline!

RSpec.configure do |config|
  config.include AcceptanceInstanceHelper, type: :feature
  OmniAuth.config.test_mode = true
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma
  Capybara.server_port = 4000

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
