class MapsController < ApplicationController
  def view
  end

  def tiles
    tiles = params.fetch("t")
    @json_tiles = []
    tiles.each do |tile|
      tile_params = tile.split('-')
      if tile_params.count == 4
        layer, x, y, z = tile_params
        if Float(x) and Float(y) and Float(z)
          x = x.to_i
          y = y.to_i
          z = z.to_i
          # max tiles = map size / 2^(max zoom - z)
          max_tiles = 512 / 2**(6-z)
          if x >= 0 and y >= 0 and z >= 0 and x < max_tiles and y < max_tiles and z <= 7
            json = generate_tile_json(layer, x, y, z)
            @json_tiles.push(json)
          end
        end
      end
    end
  end
end
