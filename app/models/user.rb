class User < ActiveRecord::Base
  belongs_to :empire

  attr_accessible :username, :email, :password, :password_confirmation
  has_secure_password

  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :username
  validates_uniqueness_of :email
end
