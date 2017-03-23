require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  context "Authorized user" do
    before do
      create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "POST create" do
      it "adds new item" do
        list = create(:list)
        name = Faker::Book.title
        post :create, {list_id: list.id, item: {name: name}}
        expect(response.body).to eq(ItemSerializer.new(Item.last).to_json)
      end
    end
  end

  context "Unauthorized user" do
    describe "POST create" do
      it "denies access to unauthorized users" do
        list = create(:list)
        name = Faker::Book.title
        post :create, {list_id: list.id, item: {name: name}}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
