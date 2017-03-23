require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
  context "Authorized user" do
    before do
      create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "POST create" do
      it "adds new list" do
        user = create(:user)
        name = Faker::Book.title
        post :create, {user_id: user.id, list: {name: name}}
        expect(response.body).to eq(ListSerializer.new(List.last).to_json)
      end
    end
  end

  context "Unauthorized user" do
    describe "POST create" do
      it "denies access to unauthorized users" do
        user = create(:user)
        name = Faker::Book.title
        post :create, {user_id: user.id, list: {name: name}}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
