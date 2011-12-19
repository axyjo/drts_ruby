class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :token_authenticatable

  belongs_to :empire
  has_and_belongs_to_many :roles, :uniq => true

  attr_accessible :username, :email, :password

  validates_presence_of :username
  validates_uniqueness_of :username
end
