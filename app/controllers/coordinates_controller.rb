class CoordinatesController < ApplicationController
  def view
    x = params[:x].to_i
    y = params[:y].to_i
    if x < 1 || y < 1 || x > Rails.configuration.game[:gameSize] || y > Rails.configuration.game[:gameSize]
      raise ActionController::RoutingError.new('Not Found')
    end

    coord = Coordinate.lnglat(x, y)
    puts coord.terrain_id

    @x = x.to_s
    @y = y.to_s
    @terrain = Terrain.find(coord.terrain_id)
    render :partial => "info"
  end
end
