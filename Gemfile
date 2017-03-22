source 'https://rubygems.org'

ruby '2.3.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'haml-rails'
gem 'angular-rails-templates'
gem 'angular_rails_csrf'
gem 'active_model_serializers'
gem 'devise_token_auth'
gem 'rack-cors'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'rack-cors'
gem 'figaro'
gem 'cancancan'
gem 'carrierwave'
gem 'cloudinary'
gem 'acts_as_list'
gem 'rails_best_practices'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara-webkit'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'letter_opener_web'
  gem 'pry'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'shoulda'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
