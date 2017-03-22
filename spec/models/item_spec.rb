require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:list) { create(:list) }
  let(:name) { 'An item to do' }
  let(:complete) { false }
  let(:item) { create(:item, name: name, complete: complete, list: list) }

  # Shoulda test for associations
  it { is_expected.to belong_to(:list) }

  # Shoulda tests for name
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name).is_at_most(255) }

  # Shoulda tests for list_id
  it { is_expected.to validate_presence_of(:list_id) }

  describe "attributes" do
    it "has list_id, complete, and name attributes" do
      expect(item).to have_attributes(name: name, complete: complete, list_id: list.id)
    end
  end
end
