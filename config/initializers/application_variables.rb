if File.exists?("/home/dotcloud/environment.json")
  app_vars = JSON.parse(File.read("/home/dotcloud/environment.json"))
  FAYE_URL = "http://f48035e8.dotcloud.com/"
else
  FAYE_URL = "http://localhost:9292/faye/"
end
