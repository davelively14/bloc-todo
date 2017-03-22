class ListSerializer < ActiveModel::Serializer
  attributes :id, :name, :user_id, :num_items

  def num_items
    object.items.count
  end
end
