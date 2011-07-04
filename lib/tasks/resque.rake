if Rails.env.production?
  require "resque/tasks"
  task "resque:setup" => :environment
end
