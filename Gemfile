source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Ruby on Rails unobtrusive scripting adapter
gem "rails-ujs"

group :development do
  # Use sqlite3 as the database for Active Record
  gem "sqlite3", "~> 1.4"
end

group :production do
  # renderではpostgresqlを使用するため、production環境では変更する。
  gem "pg", "~> 1.4"
end

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Reduces boot times through caching
gem "bootsnap", require: false

# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"

# Use ActiveStorage variant
gem "image_processing", "~> 1.2"
gem "mini_magick", "~> 4.8"

gem "email_validator", "~> 1.6"
gem "kaminari"
gem "kaminari-i18n"

gem 'webpacker', '~> 5.0'

# Generates ER-diagrams using Graphviz, a visualization library
gem 'rails-erd'


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'better_errors'
  gem 'binding_of_caller'
end

