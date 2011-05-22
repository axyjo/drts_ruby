class MapsController < ApplicationController
  def view
  end

  def tiles
    tile_size = 256
    tiles = params.fetch("t")
    @json_tiles = []
    tiles.each do |tile|
      tile_params = tile.split('-')
      if tile_params.count == 4
        type, x, y, z = tile_params
        if Float(x) and Float(y) and Float(z)
          x = x.to_i
          y = y.to_i
          z = z.to_i
          # max tiles = map size * 2^z / tile size
          max_tiles = 512 * 2**z / tile_size
          if x >= 0 and y >= 0 and z >= 0 and x < max_tiles and y < max_tiles and z < 7
            left = x*tile_size
            top = y*tile_size
            html = '<div class="map_tiles tiles-sprite tiles-'+type+'" id="'+tile+'"></div>'
            @json_tiles.push({'id' => tile, 'type' => type, 'html' => html})
          end
        end
      end
    end
  end
end
