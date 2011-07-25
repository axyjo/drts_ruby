class Coordinate < ActiveRecord::Base
  belongs_to :province
  has_one :terrain

  def lnglat(lng, lat)
    Coordinate.find_by_lng_and_lat(lng, lat)
  end

  def north
    Coordinate.lnglat(lng, lat-1)
  end

  def south
    Coordinate.lnglat(lng, lat+1)
  end

  def west
    Coordinate.lnglat(lng-1, lat)
  end

  def east
    Coordinate.lnglat(lng+1, lat)
  end
end
