require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:username) { 'test' }
  let(:password) { 'password' }
  let(:user) { create(:user, username: username, password: password, password_confirmation: password) }
  let(:another_user) { create(:user) }

  context "Authorized user" do
    before do
      create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "GET index" do
      it "returns all users" do
        @expected = []
        User.all.each {|u| @expected << UserSerializer.new(u)}

        get :index
        expect(response.body).to eq(@expected.to_json)
      end
    end

    describe "POST create" do
      it "adds new user" do
        post :create, user: {username: "newUser", password: "password"}
        expect(response.body).to eq(UserSerializer.new(User.last).to_json)
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

    describe "POST create" do
      it "denies access for unauthorized users" do
        post :create, user: {username: "newUser", password: "password"}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
