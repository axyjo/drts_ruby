if Rails.env.production?
  require 'resque'
  require 'resque_scheduler'
  require 'resque_scheduler/server'
  require 'resque/scheduler'
  require 'resque-retry'
  require 'resque-retry/server'

  uri = URI.parse(REDIS_URL)
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)

  if Resque.redis.get("resque_init_lock").nil?
    Resque.redis.set("resque_init_lock", "locked")
    Resque.redis.expire("resque_init_lock", 3600)

    # Subtract 2 zoom levels off the maximum so that the last two are generated on the fly.
    maxZoom = 4 - 2
    for z in 0..maxZoom
      maxTilesX = 2**(z+2) - 1
      maxTilesY = 2**(z+2) - 1
      for x in 0..maxTilesX
        for y in 0..maxTilesY
          tile_path = 'base/' + z.to_s + '/' + x.to_s + '/' + y.to_s
          if !File.exists?(Rails.root.join('public', 'tiles', tile_path+'.png'))
            Resque.enqueue(TileCacher, tile_path)
          end
        end
      end
    end

    Resque.redis.del("resque_init_lock")
  end
end
