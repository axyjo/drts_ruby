set :application, "drts_ruby"
set :scm, :git
set :repository,  "git://github.com/axyjo/drts_ruby.git"

set :user, "deployment"
set :use_sudo, false
set :deploy_to, "/var/www/drts_ruby"

role :web, "cali.akshayjoshi.com"                          # Your HTTP server, Apache/etc
role :app, "cali.akshayjoshi.com"                          # This may be the same as your `Web` server
role :db,  "cali.akshayjoshi.com", :primary => true # This is where Rails migrations will run

task :tail_log, :roles => :app do
  run "tail -f #{shared_path}/log/production.log"
end
