class CoordinatesController < ApplicationController
  def view
    x = params[:x].to_i
    y = params[:y].to_i
    if x < 1 || y < 1 || x > Rails.configuration.game[:gameSize] || y > Rails.configuration.game[:gameSize]
      raise ActionController::RoutingError.new('Not Found')
    end
    @test = "blah"
    render
  end
end
