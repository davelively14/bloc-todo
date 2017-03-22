require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:username) { 'test' }
  let(:password) { 'password' }
  let(:user) { create(:user, username: username, password: password, password_confirmation: password) }
  let(:another_user) { create(:user) }

  context "Authorized user" do
    before(:each) do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(username, password)
    end

    describe "GET index" do
      it "returns all users" do
        @expected = [
          UserSerializer.new(user),
          UserSerializer.new(another_user)
        ].to_json

        get :index
        expect(response.body).to eq(@expected)
      end
    end
  end

  context "Unauthorized user" do
    describe "GET index" do
      it "does not return data for unauthorized users" do
        get :index
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
