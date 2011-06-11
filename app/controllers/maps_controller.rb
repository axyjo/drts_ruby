class MapsController < ApplicationController
  def view
  end

  def click
    x = params.fetch("x")
    y = params.fetch("y")
    x = x.to_i
    y = y.to_i
  end

  def tiles
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
          # max tiles = map size / 2^z
          max_tiles = 512 / 2**z
          if x >= 0 and y >= 0 and z >= 0 and x < max_tiles and y < max_tiles and z <= 7
            html = generate_tile_html(x, y, z)
            @json_tiles.push({'id' => tile, 'type' => type, 'html' => html})
          end
        end
      end
    end
  end

  private
  def get_tile_type(x, y, z)
    sum = x+y+z
    mod = sum % 4
    if mod == 1
      return "fire"
    elsif mod == 2
      return "water"
    elsif mod == 3
      return "grass"
    elsif mod == 0
      return "rock"
    end
  end

  def generate_tile_html(x, y, z)
    tile_size = 128
    left = (x*tile_size).to_s
    top = (y*tile_size).to_s
    tile_type = get_tile_type(x, y, z)
    html = '<div class="map_tiles tiles-sprite tiles-'+tile_type+'" id="'+tile+'" style="left:'+left+'px; top:'+top+'px;"></div>'
    return html
  end
end
