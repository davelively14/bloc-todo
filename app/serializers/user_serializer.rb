class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :num_lists

  def num_lists
    object.lists.count
  end
end
