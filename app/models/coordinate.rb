class Coordinate < ActiveRecord::Base
  belongs_to :province
  has_one :terrain
end
