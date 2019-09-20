require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'factories' do
    subject { build :comment }
    it { should be_valid }
  end

  describe 'validation' do
    it { is_expected.to validate_length_of(:content).is_at_least(10).is_at_most(255) }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
