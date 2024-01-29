source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in permits.gemspec.
gemspec

group :test do
  # Use DatabaseCleaner for specs
  gem "database_cleaner"

  # Add factory_bot_rails for fixtures
  gem "factory_bot_rails"

  # Add faker for fake data
  gem "faker"

  # Use postgresql as the database for Active Record
  gem "pg"

  # Shoulda Matchers for specs
  gem "shoulda-matchers"

  # SimpleCov to check code coverage
  gem "simplecov", require: false

  # Use tzinfo-data for timezone data
  gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
end
