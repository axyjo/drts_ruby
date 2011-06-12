class Character < ActiveRecord::Base
  belongs_to :user
  belongs_to :round
  has_one :kingdom
end
