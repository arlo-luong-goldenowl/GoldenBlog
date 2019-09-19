require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  describe "#create" do
    def do_request
      post :like_unlike, params: { id: fake_post.id, format: :js }
    end

    context "Haven't logged yet" do
      let!(:fake_post) { create(:post) }
      it "redirect to login page" do
        do_request
        expect(response).to redirect_to login_path
      end
    end

    context "Already logged and post doesn't exist" do
      let!(:user) { create(:user) }
      let!(:fake_post) { build(:post, id: -78) }

      before { log_in(user) }

      it "render 404 pages" do
        do_request
        should respond_with(404)
      end
    end

    context "Already logged and post exist - like post" do
      let!(:user) { create(:user) }
      let!(:fake_post) { create(:post) }

      before { log_in(user) }

      it "render like_unlike.js, like effect" do
        expect { do_request }.to change { Like.count }.from(0).to(1)
        expect(response).to render_template :like_unlike
      end
    end

    context "Already logged, post exist, unlike post" do
      let!(:user) { create(:user) }
      let!(:fake_post) { create(:post) }
      let!(:like) { create(:like, user_id: user.id, post_id: fake_post.id) }

      before { log_in(user) }

      it "render like_unlike.js, unlike effect" do
        expect { do_request }.to change { Like.count }.from(1).to(0)
        expect(response).to render_template :like_unlike
      end
    end

  end
end
