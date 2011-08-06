class MapsController < ApplicationController
  require 'oily_png'

  # In production, save the tiles generated.
  caches_page :tiles

  # Skip checking path for tiles.
  skip_before_filter :check_path, :only => :tiles

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

      # Prefer using Imagemagick if it exists on the server.
      if File.exists?(Rails.configuration.game[:imageMagickPath]) && File.executable?(Rails.configuration.game[:imageMagickPath])
        dest = Tempfile.new('tile_dest')

        blur_sigma = (Rails.configuration.game[:maxZoom] - z)*0.75
        options = "-crop #{chunk_width}x#{chunk_height}+#{chunk_x}+#{chunk_y} +repage -scale 256x256 -blur 0x#{blur_sigma}"
        command = "#{Rails.configuration.game[:imageMagickPath]} #{path} #{options} #{dest.path}"
        `#{command}`

        response = IO.read(dest.path)
      else
        tile = ChunkyPNG::Image.from_file(path)
        # Don't crop if there is no difference between the chunk size and the slice size.
        if chunk_width != slice_size and chunk_height != slice_size
          tile.crop!(chunk_x, chunk_y, chunk_width, chunk_height)
        end
        tile.resample_nearest_neighbor!(tile.width * scale, tile.height * scale)
        response = tile.to_blob
      end

      send_data response, :type =>'image/png', :disposition => 'inline'
    end
  end
end
