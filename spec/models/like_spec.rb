require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'factories' do
    subject { build :like }
    it { should be_valid }
  end

  describe 'association' do
    it { should belong_to(:user) }
    it { should belong_to(:post) }
  end
end
