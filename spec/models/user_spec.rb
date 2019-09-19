require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }

  describe 'factories' do
    subject { build :user }
    it { should be_valid }
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to  validate_length_of(:password).is_at_least(6) }
  end

  describe 'association' do
    it { should have_many(:shares) }
    it { should have_many(:posts) }
    it { should have_many(:comments) }
  end

  describe 'methods' do
    describe 'instance methods' do
      context 'remember' do
        let!(:user) { create(:user) }
        let!(:remember_digest) { user.remember_digest }

        it 'remember token generation failure' do
          user.remember
          expect(user.reload.remember_digest).not_to eq(remember_digest)
        end
      end

      context 'forget' do
        let!(:user) { create(:user) }
        let!(:remember_digest) { user.remember_digest }

        it 'hihi' do
          user.forget
          expect(user.reload.remember_digest).to eq(nil)
        end
      end

    end
  end
end
