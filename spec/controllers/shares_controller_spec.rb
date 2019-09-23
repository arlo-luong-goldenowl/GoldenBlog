require 'rails_helper'

RSpec.describe SharesController, type: :controller do
  describe "#index" do
    def do_request
      post :index, params: { id: fake_post.id, format: :json }
    end

    let!(:fake_post) { create(:post) }

    context "Haven't logged then share" do
      it "render json" do
        do_request
        expect(fake_post.shares_counter + 1).to eq(fake_post.reload.shares_counter)
        should respond_with(200)
      end
    end

    context "Logged then share" do
      let!(:user) { create(:user) }

      before { log_in(user) }

      it "render json" do
        expect { do_request }.to change { Share.count }.from(0).to(1)
        expect(fake_post.shares_counter + 1).to eq(fake_post.reload.shares_counter)
        should respond_with(200)
      end
    end
  end
end
