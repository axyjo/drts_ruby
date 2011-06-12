class Kingdom < ActiveRecord::Base
  belongs_to :character
  belongs_to :capital, :class_name => "City", :conditions => { :capital => true }
  has_many :cities
end
