require 'rails_helper'

RSpec.describe Admin::PostsController, type: :controller do
  let!(:user){ create(:user, role: :admin) }
  describe "#index" do
    def do_request
      get :index
    end

    before { log_in(user) }

    let!(:post_1) { create(:post, status: :approved) }
    let!(:post_2) { create(:post, status: :approved) }

    it "renders posts list sored by created_at" do
      do_request
      expect(assigns(:posts)).to eq [post_2, post_1]
      expect(assigns(:posts).size).to be <= 6
      expect(response).to render_template :index
    end
  end

  describe "#new" do
    def do_request
      get :new
    end

    let!(:category_1) { create(:category) }

    before { log_in(user) }

    it "renders :new template" do
      do_request
      expect(assigns(:categories).size).to be > 0
      expect(response).to render_template :new
    end
  end

  describe "#create" do
    def do_request
      post :create, params: { post: post_params }
    end

    before { log_in(user) }

    context "valid params" do
      let!(:category) { create(:category) }
      let!(:post_params) {
        attributes_for(:post)
          .merge({
            category_id: category.id,
            user_id: user.id
          })
      }

      it "create post success" do
        expect { do_request }.to change { Post.count }.from(0).to(1)
        expect(flash[:success]).to eq "Post was successfully created."
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "invalid params" do
      let!(:post_params) { attributes_for(:post) }
      it "create post failure" do
        do_request
        expect(assigns(:post).errors.messages.length).to be > 0
        expect(response).to render_template :new
      end
    end
  end

  describe "#edit" do
    def do_request
      get :edit, params: { id: fake_post.id }
    end

    before { log_in(user) }

    context "Post exist" do
      let!(:fake_post) { create(:post) }
      it "renders :edit template" do
        do_request
        expect(response).to render_template :edit
      end
    end

    context "Post doesn't exist" do
      let!(:fake_post) { build(:post, id: -71) }
      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end
  end

  describe "#update" do
    def do_request
      patch :update, params: { id: fake_post.id, post: post_updated_attributes }
    end

    before { log_in(user) }

    context "Post doesn't exist" do
      let!(:fake_post) { build(:post, id: -21) }
      let!(:post_updated_attributes) { { title: 'Updated title abcxyz' } }
      it "update post failure" do
        do_request
        should respond_with(404)
      end
    end

    context "Post exists - valid params" do
      let!(:fake_post) { create(:post) }
      let!(:post_updated_attributes) { { title: 'Updated title abcxyz' } }

      it "update post successful" do
        do_request
        expect(flash[:success]).to eq "Post was successfully updated."
        expect(fake_post.reload.title).to eq post_updated_attributes[:title]
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "Post exists - invalid params" do
      let!(:fake_post) { create(:post) }
      let!(:post_updated_attributes) { { title: '' } }

      it "update post failure" do
        do_request
        expect(fake_post.reload.title).to eq fake_post.title
        expect(response).to render_template :edit
      end
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy, params: { id: fake_post.id }
    end

    before { log_in(user) }

    context "Post exists" do
      let!(:fake_post) { create(:post) }
      it "delete success" do
        expect { do_request }.to change { Post.count }.from(1).to(0)
        expect(flash[:success]).to eq "Post was successfully deleted."
        expect(response).to redirect_to admin_posts_path
      end
    end

    context "Post doesn't exist" do
      let!(:fake_post) { build(:post, id: -99) }
      it "delete failure" do
        do_request
        should respond_with(404)
      end
    end
  end
end
