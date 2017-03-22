class User < ActiveRecord::Base
  has_many :lists
  has_secure_password

  validates :username, presence: true, length: { minimum: 3, maximum: 30}, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
end
