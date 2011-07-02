source 'http://rubygems.org'

gem 'rails', '3.1.0.rc4'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

# Asset template engines
gem 'sass-rails', :git => 'https://github.com/rails/sass-rails.git', :branch => '3-1-stable'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Add Haml for templating
gem 'haml'

# Add compass for CSS
gem 'compass', :git => 'https://github.com/chriseppstein/compass.git', :branch => 'rails31'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

group :production do
  # Use therubyracer as our V8 engine (especially on Dotcloud)
  gem 'therubyracer'

  # Use resque for queues
  gem 'resque', :require => "resque/server"
end

# Use RMagick for tile generation.
gem 'rmagick'

# Use rack-offline to generate the HTML5 app cache
gem 'rack-offline'

# Use rails_code_qa for test coverage reports.
gem 'rails_code_qa'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end
