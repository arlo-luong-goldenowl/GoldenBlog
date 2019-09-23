require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:user) { create(:user, role: :admin) }

  before { log_in(user) }

  describe "#index" do
    def do_request
      get :index
    end

    let!(:category_1) { create(:category) }
    let!(:category_2) { create(:category) }

    it "render categories and sort by created_at" do
      do_request
      expect(assigns(:categories)).to eq [category_2, category_1]
      expect(response).to render_template :index
    end
  end

  describe "#new" do
    def do_request
      post :create, params: { category: category_params }
    end

    context "valid param" do
      let!(:category_params) { attributes_for(:category) }

      it "create category successful" do
        expect { do_request }.to change { Category.count }.from(0).to(1)
        expect(flash[:success]).to eq "Category was successfully created"
        expect(response).to redirect_to admin_categories_path
      end
    end

    context "invalid param" do
      let!(:category_params) { attributes_for(:category).merge({name: ''}) }

      it "create category failure" do
        do_request
        expect(assigns(:category).errors.messages[:name]).to eq ["can't be blank", "is too short (minimum is 3 characters)"]
        expect(response).to render_template :new
      end
    end
  end

  describe "#edit" do
    def do_request
      get :edit, params: { id: category.id }
    end

    context "category doesn't exist" do
      let!(:category) { build(:category, id: -3) }

      it "renders 404" do
        do_request
        should respond_with(404)
      end
    end

    context "category exist" do
      let!(:category) { create(:category) }

      it "renders :edit template" do
        do_request
        expect(response).to render_template :edit
      end
    end
  end

  describe "#update" do
    def do_request
      patch :update, params: { id: category.id, category: category_params }
    end

    context "category doesn't exist" do
      let!(:category) { build(:category, id: -21) }
      let!(:category_params) { attributes_for(:category) }

      it "renders 404" do
        do_request
        should respond_with(404)
      end
    end

    context "category exists and valid params" do
      let!(:category) { create(:category) }
      let!(:category_params) { attributes_for(:category) }

      it "update category successfull" do
        do_request
        expect(flash[:success]).to eq "Category was successfully updated"
        expect(response).to redirect_to admin_categories_path
      end
    end

    context "category exist but invalid params" do
      let!(:category) { create(:category) }
      let!(:category_params) { attributes_for(:category).merge({name: 'ue'}) }

      it "update category failure" do
        do_request
        expect(assigns(:category).errors.messages[:name]).to eq ["is too short (minimum is 3 characters)"]
        expect(response).to render_template :edit
      end
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy, params: { id: category.id }
    end

    context "category exist" do
      let!(:category) { create(:category) }

      it "delete category successful" do
        do_request
        expect(flash[:success]).to eq "Category was successfully deleted."
        expect(response).to redirect_to admin_categories_path
      end
    end

    context "category doesn't exist" do
      let!(:category) { build(:category, id: -21) }

      it "renders 404" do
        do_request
        should respond_with(404)
      end
    end


    context "still have some posts belong to category" do
      let!(:category) { create(:category) }
      let!(:post) { create(:post, category_id: category.id) }

      it "renders 404" do
        do_request
        expect(flash[:danger]).to eq "You can only delete when no more posts belong to this category"
        expect(response).to redirect_to admin_categories_path
      end
    end
  end


end
