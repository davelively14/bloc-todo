class User < ActiveRecord::Base
  has_many :lists, dependent: :destroy
  has_secure_password

  validates :username, presence: true, length: { minimum: 3, maximum: 30}, uniqueness: true
end
