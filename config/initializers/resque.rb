# The username doesn't matter for Redis.
ENV["REDIS_URL"] ||= "redis://game:l8SxAPzcDXQgy0KfMiUj@efbb8c00.dotcloud.com:9113"

uri = URI.parse(ENV["REDIS_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

maxZoom = 4
for z in 0..maxZoom
  maxTilesX = 2**(z+2) - 1
  maxTilesY = 2**(z+2) - 1
  for x in 0..maxTilesX
    for y in 0..maxTilesY
      Resque.enqueue(TileCacher, 'base/' + z + '/' + x + '/' + y)
    end
  end
end
