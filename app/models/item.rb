class Item < ActiveRecord::Base
  belongs_to :list

  validates :name, presence: true, length: { maximum: 255 }
  validates :list_id, presence: true
end
