source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.3"
gem "rails", "~> 7.0.4"
gem "sprockets-rails"

gem 'sqlite3'

gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data"
gem "bootsnap", require: false
gem "pry"
gem 'pg', '~> 1.4', '>= 1.4.5'
gem 'activerecord-import'
gem 'database_cleaner-active_record'
gem 'hotwire-rails', '~> 0.1.3'
gem 'importmap-rails'
gem 'requestjs-rails'
gem 'date', '~> 0.0.1'
gem 'chartkick'
gem 'groupdate' #allows group_by_day functionality
gem 'working_hours'
gem 'solargraph', group: :development

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :production  do
  
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem 'ransack'