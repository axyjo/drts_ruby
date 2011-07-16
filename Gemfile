source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Asset template engines
gem 'sass-rails', :git => 'https://github.com/rails/sass-rails.git', :branch => '3-1-stable'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Add Haml for templating
gem 'haml'

# Add compass for CSS
gem 'compass', :git => 'https://github.com/chriseppstein/compass.git', :branch => 'rails31'

# Use chunky_png/oily_png for tile generation.
gem 'oily_png'

# Use rails_code_qa for test coverage reports.
gem 'rails_code_qa'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  # Use therubyracer as our V8 engine (especially on Dotcloud)
  gem 'therubyracer'

  # Use resque for queues
  gem 'resque', :require => "resque/server"
  gem 'resque-scheduler', :require => "resque_scheduler/server"

  # Use the mysql2 gem for the DB.
  gem 'mysql2'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development do
  gem 'sqlite3'
end
