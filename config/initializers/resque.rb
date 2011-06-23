ENV["REDIS_URL"] ||= "redis://axyjo:00b8673cde673c23494ecbb2d49c26f3@bluegill.redistogo.com:9301/"

uri = URI.parse(ENV["REDIS_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

