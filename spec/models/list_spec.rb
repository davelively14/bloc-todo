require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { create(:user) }
  let(:name) { 'My List' }
  let(:list) { create(:list, user: user, name: name) }

  # Shoulda test for associations
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:items) }

  # Shoulda test for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(100) }

  # Shoulda test for user_id
  it { is_expected.to validate_presence_of(:user_id) }

  describe "attributes" do
    it "has user_id and name attributes" do
      expect(list).to have_attributes(name: name, user_id: user.id)
    end
  end
end
