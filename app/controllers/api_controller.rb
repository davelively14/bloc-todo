class ApiController < ApplicationController
  skip_before_action :verify_authentication_token

  private

  def authenticated?
    authenticate_or_request_with_http_basic {|username, password| User.where(username: username).first.try(:authenticate, password).present? }
  end
end
