class Unit < ActiveRecord::Base
  def is_land?
    type == 1
  end
end
