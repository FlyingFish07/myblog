source 'https://rubygems.org'

gem 'rails', '4.2.4'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails'
gem 'jquery-rails'
# gem 'turbolinks'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'sunspot_rails'
gem 'carrierwave'
gem 'stringex'
gem 'rakismet'

# platforms :ruby do
# #  gem 'pg'
#   gem 'sqlite3'
# end

# platforms :jruby do
#   # The stable version has not yet supported Rails 4
#   gem 'activerecord-jdbcsqlite3-adapter', '1.3.0.beta2'
#   gem 'trinidad'
#   gem 'jruby-openssl'
# end

#Use passenger as the web server
gem "passenger"
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
#gem 'RedCloth', '~> 4.2.9', :require => 'redcloth'
gem 'kramdown'
gem 'rouge','~>1.10.1'
gem 'ruby-openid', :require => 'openid'
gem 'rack-openid', :require => 'rack/openid'
gem 'chronic'
#gem 'coderay', '~> 1.0.5'
gem 'lesstile', '~> 1.1.0'
gem 'formtastic'
gem 'formtastic-bootstrap'
gem 'will_paginate', '~> 3.0.2'
gem 'exception_notification', '~> 2.5.2'
gem 'omniauth'
# gem 'omniauth-google-oauth2'
gem 'omniauth-openid'
gem 'acts-as-taggable-on', '~> 3.5'
gem 'devise'
gem 'pundit'


# Comment this line if you donot use mysql
gem 'mysql2', '~>0.3.20'
#Uncomment if you want to use sqlite3
# gem 'sqlite3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :test do
  gem 'simplecov', :require => false
  gem 'database_cleaner'
  gem 'cucumber-rails',    :require => false
  gem 'cucumber-websteps', :require => false
  gem 'selenium-webdriver'
  gem 'factory_girl'
  gem 'rspec'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'nokogiri', '~> 1.6.0'
  gem 'webrat'
end

# Uncomment if you want easy profiling in development.
#group :development do
#  gem 'rack-mini-profiler'
#end

group :development, :test do
  # gem 'web-console', '3.0.0'
  gem 'spork'
  gem 'rspec-rails'
  gem 'byebug','8.2.2'
  gem 'better_errors'
  gem 'quiet_assets'
  gem 'awesome_print'
end
