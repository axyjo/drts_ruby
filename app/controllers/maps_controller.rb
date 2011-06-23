class MapsController < ApplicationController
  def view
  end

  def tiles
    img_dir = Rails.root.join("app", "assets", "images")

    map = ChunkyPNG::Image.from_file(img_dir.join("base_map_new.png"))
    z = params[:z]
    if 2**z < map.height
      scale = 1.0/2**(5-z)
      height_factor = map.height/2**z
      x = params[:x]
      y = params[:y]
      if x < map.height/2**(13-z)
        if y < map.height/2**(13-z)
          tile = map.crop(x*height_factor, y*height_factor, height_factor, height_factor)
          tile = tile.resample(scale*tile.width, scale*tile.height)
        end
      end
    end
    render :text => tile.to_blob
  end
end
