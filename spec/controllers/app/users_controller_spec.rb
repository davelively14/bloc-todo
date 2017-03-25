require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  context "Authorized user" do
    before do
      @user = create(:user, username: "auth_user", password: "password", password_confirmation: "password")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("auth_user", "password")
    end

    describe "GET index" do
      it "returns all users" do
        5.times do
          create(:user)
        end

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

    describe "DELETE destroy" do
      it "deletes a user" do
        delete :destroy, id: @user.id
        expect(User.where(id: @user.id)).to eq([])
      end

      it "deletes associated lists" do
        2.times { create(:list, user: @user) }
        expect{
          delete :destroy, id: @user.id
        }.to change(List, :count).by(-2)
      end

      it "cannot delete another user" do
        new_user = create(:user)
        delete :destroy, id: new_user.id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end

  context "Unauthorized user" do
    describe "GET index" do
      it "denies access for unauthorized users" do
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

    describe "DELETE destroy" do
      it "denies access for unauthorized users" do
        user = create(:user)
        delete :destroy, id: user.id
        expect(response.body).to eq("HTTP Basic: Access denied.\n")
      end
    end
  end
end
