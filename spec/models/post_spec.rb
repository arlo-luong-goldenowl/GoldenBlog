require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'factories' do
    subject { build :post }
    it { should be_valid }
  end

  describe 'validation' do
    it { is_expected.to validate_length_of(:title).is_at_least(10).is_at_most(255) }
    it { is_expected.to validate_length_of(:content).is_at_least(20) }
    it { is_expected.to validate_length_of(:category_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
    it { should have_many(:likes) }
    it { should have_many(:comments) }
  end
end
