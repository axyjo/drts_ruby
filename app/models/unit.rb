class Unit < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :type
  validates_numericality_of :type, :only_integer => true, :greater_than => 0

  def is_land?
    type == 1
  end
end
