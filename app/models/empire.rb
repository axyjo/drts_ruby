class Empire < ActiveRecord::Base
  has_many :provinces
  has_many :users
end
