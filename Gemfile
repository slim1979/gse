source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'dotenv-rails'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'slim-rails'
gem 'devise'
gem 'rubocop'
gem 'twitter-bootstrap-rails'
gem 'less-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'carrierwave'
gem 'remotipart'
gem 'nested_form'
gem 'skim'
gem 'gon'
gem "sprockets", '3.6.3'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper', '4.2.6'
gem 'active_model_serializers', '~> 0.9.3'
gem 'sidekiq'
gem 'whenever', require: false
gem 'sinatra', require: false
<<<<<<< HEAD
gem 'dotenv'
gem 'mysql2'
gem 'thinking-sphinx'
=======
gem 'mysql2', '>= 0.3.18', :platform => :ruby
gem 'thinking-sphinx', '~> 3.4.2'
>>>>>>> 544183f8cfd7ea5238c1a4e2abb4fa8ab5941619

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'pry-byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'launchy'
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'pry-rails'
  gem 'capybara-email'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener'
  # Use Capistrano for deployment
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
end

group :test do
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'json_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
