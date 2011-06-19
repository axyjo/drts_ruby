class MapsController < ApplicationController
  def view
    @initial_tiles = get_initial_tiles.to_json
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
        layer, x, y, z = tile_params
        if Float(x) and Float(y) and Float(z)
          x = x.to_i
          y = y.to_i
          z = z.to_i
          # max tiles = map size / 2^z
          max_tiles = 512 / 2**z
          if x >= 0 and y >= 0 and z >= 0 and x < max_tiles and y < max_tiles and z <= 7
            json = generate_tile_json(layer, x, y, z)
            @json_tiles.push(json)
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
      return "sand"
    elsif mod == 2
      return "water"
    elsif mod == 3
      return "grass"
    elsif mod == 0
      return "rock"
    end
  end

  def generate_tile_json(layer, x, y, z)
    tile_size = 64
    left = (x*tile_size).to_s
    top = (y*tile_size).to_s
    tile_type = get_tile_type(x, y, z)
    id = "#{layer}-#{x}-#{y}-#{z}"
    html = "<div class=\"map_tiles tiles-sprite tiles-"+tile_type+"\" id=\""+id+"\" style='left:"+left+"px; top:"+top+"px;'></div>"
    return {'id' => id, 'type' => layer, 'tile' => tile_type, 'left' => left, 'top' => top}
  end

  def get_initial_tiles
    default_z = 5
    max_tiles = 512 / 2**default_z
    map_size = 512
    json_tiles = []
    for x in 0..max_tiles-1
      for y in 0..max_tiles-1
        temp = generate_tile_json('base', x, y, default_z)
        json_tiles.push(temp)
      end
    end
    return json_tiles
  end
end
