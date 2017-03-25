class ApiController < ApplicationController
  skip_before_action :verify_authentication_token
  protect_from_forgery

  private

  def authenticated?
    authenticate_or_request_with_http_basic {|username, password| authorized?(username, password, request) }
  end

  # Given a current_user and an ActionController::Request object, we determine
  # if the current_user is modifiying an item, list, or user record. If so, we
  # then determine if
  def modify?(current_user, request)
    if request.delete? || request.post? || request.put?
      case request.params["controller"]
      when "api/items"
        user = request.post? ? List.find(request.params["list_id"]).get_user : Item.find(request.params["id"]).get_user
        return current_user == user
      when "api/lists"
        user = request.post? ? User.find(request.params["user_id"]) : User.find(request.params["user_id"])
        return current_user == user
      when "api/users"
        puts "users"
      else
        puts "This api is not "
        false
      end
    else
      true
    end
    true
  end

  # Authenticates user by passing the password to the :authenticate black box,
  # and checks authorization via modify? method
  def authorized?(username, password, request)
    current_user = User.where(username: username).first
    current_user.try(:authenticate, password).present? && modify?(current_user, request)
  end
end
