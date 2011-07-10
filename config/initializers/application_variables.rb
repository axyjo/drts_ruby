if File.exists?("/home/dotcloud/environment.json")
  app_vars = JSON.parse(File.read("/home/dotcloud/environment.json"))
  REDIS_URL = app_vars["DOTCLOUD_QUEUE_REDIS_URL"]
  FAYE_URL = "http://f48035e8.dotcloud.com/"
else
  REDIS_URL = ""
  FAYE_URL = "http://localhost:9292/faye/"
end
