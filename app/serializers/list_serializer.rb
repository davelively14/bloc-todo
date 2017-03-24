class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :permissions, :num_items

  def num_items
    object.items.count
  end
end
