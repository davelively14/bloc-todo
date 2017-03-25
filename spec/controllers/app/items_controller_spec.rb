require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  context "Authorized user" do
    before do
      user = create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      @list = create(:list, user_id: user.id)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "POST create" do
      it "adds new item" do
        name = Faker::Book.title
        post :create, {list_id: @list.id, item: {name: name}}
        expect(response.body).to eq(ItemSerializer.new(Item.last).to_json)
      end

      it "cannot create a new item for another user" do
        name = Faker::Book.title
        new_user = create(:user)
        new_list = create(:list, user_id: new_user.id)
        post :create, {list_id: new_list.id, item: {name: name}}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "DELETE destroy" do
      it "deletes an item" do
        item = create(:item, list_id: @list.id)
        delete :destroy, id: item.id, list_id: item.list_id
        expect(Item.where(id: item.id)).to eq([])
      end

      it "cannot delete an item belonging to another user" do
        new_user = create(:user)
        new_list = create(:list, user_id: new_user.id)
        item = create(:item, list_id: new_list.id)
        delete :destroy, id: item.id, list_id: item.list_id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "PUT update" do
      it "updates existing item" do
        item = create(:item, name: "Old name", complete: false, list_id: @list.id)
        new_name = "New name"
        new_complete = true

        put :update, id: item.id, item: {name: new_name, complete: new_complete}
        new_item = Item.find(item.id)

        expect(new_item.name).to eq(new_name)
        expect(new_item.complete).to eq(new_complete)
      end

      it "cannot update an item belonging to another user" do
        new_user = create(:user)
        new_list = create(:list, user_id: new_user.id)
        item = create(:item, name: "Old name", complete: false, list_id: new_list.id)
        new_name = "New name"
        new_complete = true

        put :update, id: item.id, item: {name: new_name, complete: new_complete}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "GET index" do
      it "returns items for a list owend by current user" do
        5.times { create(:item, list_id: @list.id) }

        @expected = []
        Item.all.each {|i| @expected << ItemSerializer.new(i)}

        get :index, list_id: @list.id
        expect(response.body).to eq(@expected.to_json)
      end

      it "returns items for a list owned by another user" do
        list = create(:list)
        5.times { create(:item, list_id: list.id) }

        @expected = []
        Item.all.each {|i| @expected << ItemSerializer.new(i)}

        get :index, list_id: list.id
        expect(response.body).to eq(@expected.to_json)
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
      it "denies access to unauthorized users" do
        item = create(:item, name: "Old name", complete: false)
        new_name = "New name"
        new_complete = true

        put :update, id: item.id, item: {name: new_name, complete: new_complete}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "GET index" do
      it "denies access to unauthorized users" do
        list = create(:list)
        5.times { create(:item, list_id: list.id) }

        @expected = []
        Item.all.each {|i| @expected << ItemSerializer.new(i)}

        get :index, list_id: list.id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
