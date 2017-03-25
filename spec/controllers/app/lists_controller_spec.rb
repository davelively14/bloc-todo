require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
  context "Authorized user" do
    before do
      @user = create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "POST create" do
      it "adds new list" do
        name = Faker::Book.title
        post :create, {user_id: @user.id, list: {name: name}}
        expect(response.body).to eq(ListSerializer.new(List.last).to_json)
      end

      it "cannot add a new list for another user" do
        new_user = create(:user)
        name = Faker::Book.title
        post :create, {user_id: new_user.id, list: {name: name}}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "DELETE destroy" do
      it "deletes a list" do
        list = create(:list, user_id: @user.id)
        delete :destroy, id: list.id, user_id: list.user_id
        expect(List.where(id: list.id)).to eq([])
      end

      it "deletes associated items" do
        list = create(:list, user_id: @user.id)
        2.times { create(:item, list: list) }
        expect{
          delete :destroy, id: list.id, user_id: list.user_id
        }.to change(Item, :count).by(-2)
      end

      it "cannot delete another user's list" do
        new_user = create(:user)
        list = create(:list, user_id: new_user.id)
        delete :destroy, id: list.id, user_id: list.user_id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "PUT update" do
      it "updates existing list" do
        list = create(:list, user: @user, name: "Old name", permissions: :priv)
        new_name = "New name"
        new_permissions = :pub

        put :update, id: list.id, user_id: @user.id, list: {name: new_name, permissions: new_permissions}
        new_list = List.find(list.id)

        expect(new_list.name).to eq(new_name)
        expect(new_list.pub?).to be_truthy
      end

      it "returns error with wrong invalid paramter" do
        list = create(:list, user: @user, name: "Old name", permissions: :priv)
        new_name = "New name"
        new_permissions = :not_supported

        expect{
          put :update, id: list.id, user_id: @user.id, list: {name: new_name, permissions: new_permissions}
        }.to raise_error(ArgumentError)
      end

      it "cannot update a list belonging to another user" do
        new_user = create(:user)
        list = create(:list, user: new_user, name: "Old name", permissions: :priv)
        new_name = "New name"
        new_permissions = :pub

        put :update, id: list.id, user_id: new_user.id, list: {name: new_name, permissions: new_permissions}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "GET index" do
      it "returns all lists for current user" do
        5.times { create(:list, user_id: @user.id) }

        @expected = []
        List.all.each {|u| @expected << ListSerializer.new(u)}

        get :index, user_id: @user.id
        expect(response.body).to eq(@expected.to_json)
      end

      it "returns all lists for another user" do
        new_user = create(:user)
        5.times { create(:list, user_id: new_user.id) }

        @expected = []
        List.all.each {|u| @expected << ListSerializer.new(u)}

        get :index, user_id: new_user.id
        expect(response.body).to eq(@expected.to_json)
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

    describe "DELETE destroy" do
      it "denies access to unauthorized users" do
        list = create(:list)
        delete :destroy, id: list.id, user_id: list.user_id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end

    describe "PUT update" do
      it "denies access to unauthorized user" do
        user = create(:user)
        list = create(:list, user: user, name: "Old name", permissions: :priv)
        new_name = "New name"
        new_permissions = :pub

        put :update, id: list.id, user_id: user.id, list: {name: new_name, permissions: new_permissions}
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
