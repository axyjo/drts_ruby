source 'http://rubygems.org'

# Use the 3.1.3 release of Rails.
gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Asset template engines
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Add Haml for templating
gem 'haml'

# Add compass for CSS
gem 'compass', '~>0.12.alpha'

# Use bcrypt-ruby for password hashing.
gem 'bcrypt-ruby'

# Use rails_code_qa for test coverage reports.
gem 'rails_code_qa'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  # Use therubyracer as our V8 engine (especially on Dotcloud)
  gem 'therubyracer'

  # Use the mysql2 gem for the DB.
  gem 'mysql2'
end

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
end

group :development do
  gem 'sqlite3'
end
