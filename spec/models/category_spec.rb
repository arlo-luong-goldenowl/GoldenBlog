require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'factories' do
    subject { build :category }
    it { should be_valid }
  end

  describe 'validation' do
    it { is_expected.to validate_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  describe 'association' do
    it { should have_many(:posts) }
  end
end
