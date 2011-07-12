class User < ActiveRecord::Base
  include Roles::RoleMethods

  belongs_to :empire
  has_and_belongs_to_many :roles, :uniq => true

  attr_accessible :username, :email, :password, :password_confirmation
  has_secure_password

  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :username
  validates_uniqueness_of :email

  def privileges
    roles.map(&:privileges).flatten
  end
end
