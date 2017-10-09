require 'rails_helper'

RSpec.configure do |config|

  config.include AcceptanceInstanceHelper, type: :feature
  config.extend AcceptanceMacros, type: :feature

  Capybara.javascript_driver = :webkit

  config.use_transactional_fixtures = false

  config.before( :suite ) do
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
  end

  config.around( :each ) do |spec|
    if spec.metadata[:js]
      # JS => doesn't share connections => can't use transactions
      spec.run
      DatabaseCleaner.clean_with :deletion
    else
      # No JS/Devise => run with Rack::Test => transactions are ok
      DatabaseCleaner.start
      spec.run
      DatabaseCleaner.clean

      # see https://github.com/bmabey/database_cleaner/issues/99
      begin
        ActiveRecord::Base.connection.send :rollback_transaction_records, true
      rescue
      end
    end
  end

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
