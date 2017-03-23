class User < ActiveRecord::Base
  has_many :lists
  has_secure_password

  validates :username, presence: true, length: { minimum: 3, maximum: 30}, uniqueness: true
end
