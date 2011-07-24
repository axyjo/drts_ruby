class MapsController < ApplicationController
  require 'oily_png'

  # In production, save the tiles generated.
  caches_page :tiles

  def view
  end

  def tiles
    slice_size = 2048
    z = params[:z].to_i
    if z >= 0 and z <= Rails.configuration.game[:maxZoom]
      scale = 2**(z-3)

      # Chunk count is the number of chunks in the tile at the current zoom.
      chunk_count = 2**z

      # Calculate which pre-cut tile will contain what we want.
      tile_x = (params[:x].to_f/chunk_count).floor
      tile_y = (params[:y].to_f/chunk_count).floor

      # Calculate how much of the pre-cut tile we want.
      chunk_width = slice_size / 2**z
      chunk_height = slice_size / 2**z
      chunk_x = (params[:x].to_i % chunk_count) * chunk_width
      chunk_y = (params[:y].to_i % chunk_count) * chunk_height

      # Get the tile we want.
      img_dir = Rails.root.join("app", "assets", "images", "map", params[:type], tile_x.to_s)
      path = img_dir.join(tile_y.to_s + ".png").to_s
      tile = ChunkyPNG::Image.from_file(path)

      # Don't crop if there is no difference between the chunk size and the slice size.
      if chunk_width != slice_size and chunk_height != slice_size
        tile.crop!(chunk_x, chunk_y, chunk_width, chunk_height)
      end
      tile.resample_nearest_neighbor!(tile.width * scale, tile.height * scale)

      send_data tile.to_blob, :type =>'image/png', :disposition => 'inline'
    end
  end
end
