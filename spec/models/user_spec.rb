require 'rails_helper'

RSpec.describe User, type: :model do
  let(:username) { 'testuser' }
  let(:password) { 'password' }
  let(:user) { create(:user, username: username, password: password, password_confirmation: password) }

  # Shoulda test for associations
  it { is_expected.to have_many(:lists) }

  # Shoulda test for username
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_most(30) }
  it { is_expected.to validate_length_of(:username).is_at_least(3) }

  describe "attributes" do
    it "has email and username attributes" do
      expect(user).to have_attributes(username: username)
    end

    it "has a secure password" do
      expect(user.try(:authenticate, "wrong")).to be_falsey
      expect(user.try(:authenticate, password)).to eq(user)
    end
  end
end
