class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :num_lists

  def num_lists
    object.lists.count
  end
end
