require 'rails_helper'

RSpec.describe User, type: :model do
  let(:username) { 'testuser' }
  let(:email) { 'testuser@bloc.io' }
  let(:password) { 'password' }
  let(:user) { create(:user, username: username, email: email, password: password, password_confirmation: password) }

  # Shoudla test for email
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to_not allow_value('dc.com').for(:email) }
  it { is_expected.to_not allow_value('dc@com').for(:email) }
  it { is_expected.to allow_value('dc@d.com').for(:email) }

  # Shoulda test for username
  it { is_expected.to validate_presence_of(:username) }
  it { is_expected.to validate_uniqueness_of(:username) }
  it { is_expected.to validate_length_of(:username).is_at_most(30) }
  it { is_expected.to validate_length_of(:username).is_at_least(3) }

  describe "attributes" do
    it "has email and username attributes" do
      expect(user).to have_attributes(email: email, username: username)
    end

    it "has a secure password" do
      expect(user.try(:authenticate, "wrong")).to be_falsey
      expect(user.try(:authenticate, password)).to eq(user)
    end
  end
end
