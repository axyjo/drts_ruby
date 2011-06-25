# The username doesn't matter for Redis.
ENV["REDIS_URL"] ||= "redis://game:l8SxAPzcDXQgy0KfMiUj@efbb8c00.dotcloud.com:9113"

uri = URI.parse(ENV["REDIS_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

