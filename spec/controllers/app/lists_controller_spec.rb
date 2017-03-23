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

    describe "DELETE destroy" do
      it "deletes a list" do
        list = create(:list)
        delete :destroy, id: list.id, user_id: list.user_id
        expect(List.where(id: list.id)).to eq([])
      end

      it "deletes associated items" do
        list = create(:list)
        2.times { create(:item, list: list) }
        expect{
          delete :destroy, id: list.id, user_id: list.user_id
        }.to change(Item, :count).by(-2)
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
  end
end
