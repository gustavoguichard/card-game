source 'https://rubygems.org'
ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Frontend stuff
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem "slim", ">= 1.3.6"
gem "slim-rails", '>= 1.1.0'
gem 'browser' # To detect browser version
gem 'compass-rails', '>= 1.1.7'
gem 'semantic-mixins'
gem 'foundation-rails'
gem 'initjs'

gem 'google-analytics-rails'

# Server
gem 'unicorn'

gem 'geocoder'
gem 'simple_form'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'will_paginate-foundation'

group :production do
  gem 'heroku-deflater', '~> 0.4.1'
  gem 'rails_12factor'
  gem 'wkhtmltopdf-heroku'
end

group :development do
  gem 'annotate', github: 'ctran/annotate_models', branch: 'develop'
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  #use profiler gem only when profiling the app
  #gem 'rack-mini-profiler'
end