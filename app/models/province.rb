class Province < ActiveRecord::Base
  belongs_to :empire
  has_many :coordinates
end
