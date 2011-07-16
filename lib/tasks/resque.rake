if Rails.env.production?
  require "resque/tasks"
  require "resque_scheduler/tasks"
  task "resque:setup" => :environment
end
