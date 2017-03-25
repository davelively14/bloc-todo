class ApiController < ApplicationController
  skip_before_action :verify_authentication_token
  protect_from_forgery

  private

  def authenticated?
    authenticate_or_request_with_http_basic {|username, password| authorized?(username, password, request) }
  end

  def modify?(current_user, request)
    if request.delete? || request.post? || request.put?
      case request.params["controller"]
      when "api/items"
        # puts "params list_id: #{request.params["list_id"]}, method: #{request.method}, list's user_id: #{List.find(request.params["list_id"]).user_id}"
        user = request.post? ? List.find(request.params["list_id"]).get_user : Item.find(request.params["id"]).get_user
        return current_user == user
      when "api/users"
        puts "users"
      when "api/lists"
        puts "lists"
      else
        puts "nothing above"
      end
    else
      true
    end
    true
  end

  def authorized?(username, password, request)
    current_user = User.where(username: username).first
    current_user.try(:authenticate, password).present? && modify?(current_user, request)
  end
end
