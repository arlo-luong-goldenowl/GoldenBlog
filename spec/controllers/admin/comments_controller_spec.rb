require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  let!(:user) { create(:user, role: :admin) }
  describe "#index" do
    def do_request
      get :index
    end

    before { log_in(user) }

    let!(:comment_1) { create(:comment) }
    let!(:comment_2) { create(:comment) }

    it "renders :index template" do
      do_request
      expect(assigns(:comments)).to eq [comment_2, comment_1]
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy, params: { id: comment.id }
    end

    before { log_in(user) }

    context "Comment exist" do
      let!(:comment) { create(:comment) }

      it "delete comment successful" do
        expect { do_request }.to change { Comment.count }.from(1).to(0)
        expect(flash[:success]).to eq "Comment was successfully deleted."
        expect(response).to redirect_to admin_comments_path
      end
    end

    context "Comment doesn't exist" do
      let!(:comment) { build(:comment, id: -31) }

      it "delete comment failure" do
        do_request
        should respond_with(404)
      end
    end
  end


end
