source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Frontend stuff
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "slim", ">= 1.3.6"
gem "slim-rails", '>= 1.1.0'
gem "high_voltage"
gem 'browser' # To detect browser version
gem 'compass-rails', '>= 1.1.7'
# gem 'semantic-mixins'

gem 'google-analytics-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Server
gem 'unicorn'

group :production do
  gem 'heroku-deflater', '~> 0.4.1'
  gem 'rails_12factor'
end

group :development do
  gem 'annotate', github: 'ctran/annotate_models', branch: 'develop'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  #use profiler gem only when profiling the app
  #gem 'rack-mini-profiler'
end