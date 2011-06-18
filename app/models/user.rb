class User < ActiveRecord::Base
  has_many :characters, :dependent => :destroy

  attr_accessible :username, :email, :password, :password_confirmation
  has_secure_password

  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :username
  validates_uniqueness_of :email
end
