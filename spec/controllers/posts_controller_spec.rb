require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "#index" do
    def do_request
      get :index
    end

    let!(:post_1) { create(:post, status: :approved) }
    let!(:post_2) { create(:post, status: :approved) }

    it 'renders posts list' do
      do_request
      expect(assigns(:posts)).to eq [post_2, post_1]
      expect(response).to render_template :index
    end

    context 'sorting by created_at DESC' do
      let(:params) { { sort: 'created_at', direction: 'desc' } }

      it 'returns posts correct' do
        do_request
        expect(assigns(:posts)).to eq [post_2, post_1]
        expect(response).to render_template :index
      end
    end
  end

  describe "#show" do
    def do_request(id)
      get :show, params: { id: id }
    end

    context "Post doesn't exist" do
      let!(:post) { create(:post, status: :approved) }
      it "renders :show template" do
        do_request(-69)
        expect(assigns(:post)).to be_nil
        should respond_with(404)
      end
    end

    context "Post exist and status is approved" do
      let!(:post) { create(:post, status: :approved) }

      it "renders :show template" do
        do_request(post.id)
        expect(assigns(:post)).not_to be_nil
        expect(response).to render_template :show
      end
    end

    context "Post exist but status is not approved" do
      let!(:fake_post) { create(:post, status: :rejected) }
      it "renders " do
        do_request(fake_post.id)
        expect(assigns(:post)).not_to be_nil
        should respond_with(404)
      end
    end
  end

  describe "#new" do
    def do_request
      get :new
    end

    let!(:user) { create(:user) }
    let!(:category_1) { create(:category) }

    before { log_in(user) }

    it "renders :new template" do
      do_request
      expect(assigns(:categories)).to eq [category_1]
      expect(response).to render_template :new
    end
  end

  describe "#create" do
    def do_request
      post :create, params: { post: post_attributes }
    end

    let!(:user) { create(:user) }
    let!(:category) { create(:category) }

    before { log_in(user) }

    context "valid params" do
      let(:post_attributes) {
        attributes_for(:post)
        .merge({
          category_id: category.id,
          user_id: user.id
        })
      }

      it "create post successful" do
        expect { do_request }.to change { Post.count }.from(0).to(1)
        expect(response).to redirect_to posts_path
      end
    end

    context "invalid params" do
      let(:post_attributes) {
        attributes_for(:post)
        .merge({
          category_id: category.id,
          user_id: user.id,
          title: 'short',
          content: 'Blah blah blah blah blah content 123156'
        })
      }

      it "create post failure" do
        do_request
        expect(assigns(:post).errors.messages[:title][0]).to eq "is too short (minimum is 10 characters)"
        expect(response).to render_template :new
      end
    end
  end

  describe "#edit" do
    def do_request
      get :edit, params: { id: post.id }
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "Post exist and belongs to current user" do
      let!(:post) { create(:post, user_id: user.id) }

      it "renders :edit template" do
        do_request
        expect(response).to render_template :edit
      end
    end

    context "Post exist but doesn't belong to current user" do
      let!(:post) { create(:post) }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end

    context "Post doesn't exist" do
      let!(:post) { build(:post, id: -699) }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end
  end

  describe "#update" do
    def do_request
      patch :update, params: {id: post.id, post: post_updated_attributes }
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "Post doesn't exist" do
      let!(:post) { build(:post, id: -699) }
      let!(:post_updated_attributes) { { title: 'Updated title abcxyz' } }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end

    context "Post exists but doesn't belong to current user" do
      let!(:post) { create(:post) }
      let!(:post_updated_attributes) { { title: 'Updated title abcxyz' } }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end

    context "Post exists and belongs to current user - valid params" do
      let!(:post) { create(:post, user_id: user.id) }
      let!(:post_updated_attributes) { { title: 'Updated title abcxyz' } }

      it "update post successful" do
        do_request
        expect(post.reload.title).to eq post_updated_attributes[:title]
        expect(flash[:success]).to eq "Post was successfully edited."
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end

    context "Post exists and belongs to current user - invalid params" do
      let!(:post) { create(:post, user_id: user.id) }
      let!(:post_updated_attributes) { { title: '' } }

      it "update post failure" do
        do_request
        expect(post.reload.title).to eq post.title
        expect(response).to render_template :edit
      end
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy, params: { id: post.id }
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "Post doesn't exist" do
      let!(:post) { build(:post, id: -699) }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end

    context "Post exists but doesn't belong to current user" do
      let!(:post) { create(:post) }

      it "renders 404 page" do
        do_request
        should respond_with(404)
      end
    end

    context "Post exists and belongs to current user - valid params" do
      let!(:post) { create(:post, user_id: user.id) }

      it "Destroy post successful" do
        expect { do_request }.to change { Post.count }.by(-1)
        expect(flash[:success]).to eq "Post was successfully deleted."
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end
  end
end
