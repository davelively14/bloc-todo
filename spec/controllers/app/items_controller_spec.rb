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

    describe "DELETE destroy" do
      it "deletes an item" do
        item = create(:item)
        delete :destroy, id: item.id, list_id: item.list_id
        expect(Item.where(id: item.id)).to eq([])
      end
    end

    describe "PUT update" do
      it "updates existing item" do
        item = create(:item, name: "Old name", complete: false)
        new_name = "New name"
        new_complete = true

        put :update, id: item.id, item: {name: new_name, complete: new_complete}
        new_item = Item.find(item.id)

        expect(new_item.name).to eq(new_name)
        expect(new_item.complete).to eq(new_complete)
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

    describe "DELETE destroy" do
      it "denies access to unauthorized users" do
        item = create(:item)
        delete :destroy, id: item.id, list_id: item.list_id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "PUT update" do
      it "deines access to unauthorized users" do
        item = create(:item, name: "Old name", complete: false)
        new_name = "New name"
        new_complete = true

        put :update, id: item.id, item: {name: new_name, complete: new_complete}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
