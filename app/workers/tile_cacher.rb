class TileCacher
  @queue = :map_queue
  def self.perform(tile_path)
    uri = URI.parse('http://9bdf9670.dotcloud.com/tiles/' + tile_path + '.png')
    request = Net::HTTP.get(uri)
  end
end

