class List < ActiveRecord::Base
  belongs_to :user
  has_many :items, dependent: :destroy

  enum permissions: [:priv, :pub]

  validates :name, presence: true, length: { maximum: 100 }
  validates :user_id, presence: true
end
