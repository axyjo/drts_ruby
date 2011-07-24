class Terrain < ActiveRecord::Base
  attr_accessible :name, :blue_value

  validates_presence_of :name
  validates_numericality_of :blue_value, :only_integer => true, :greater_than => -1, :less_than => 256
end
