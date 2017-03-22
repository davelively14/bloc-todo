class ItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :complete, :list_id
end
