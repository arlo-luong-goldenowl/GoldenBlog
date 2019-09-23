require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "#create" do
    def do_request
      post :create, params: { post_id: fake_post.id, comment: comment_params, format: :js }
    end

    let!(:fake_post) { create(:post) }

    context "Haven't logged yet" do
      let!(:comment_params) { { from_page: "index_controller", content: "blah blah blah blahb lbah" } }
      it "redirect to login page" do
        do_request
        expect(response).to redirect_to login_path
      end
    end

    context "Already logged" do
      let!(:comment_params) { { from_page: "index_controller", content: "blah blah blah blahb lbah" } }
      let!(:user) { create(:user) }

      before { log_in(user) }

      it "render create.js - comment successful" do
        expect { do_request }.to change { Comment.count }.from(0).to(1)
        expect(response).to render_template :create
      end
    end
  end
end
