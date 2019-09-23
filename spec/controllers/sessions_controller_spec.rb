require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    def do_request
      get :new
    end

    context "Haven't logged yet" do
      it "renders :new template" do
        do_request
        expect(response).to render_template :new
      end
    end

    context "Already logged" do
      let!(:user) { create(:user) }

      before { log_in(user) }

      it "redirect to profile page" do
        do_request
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end
  end

  describe "#create" do
    def do_request
      post :create, params: { session: session_params}
    end

    let!(:user) { create(:user, email: "aaa@gmail.com", password: "aaaaaa", password_confirmation: "aaaaaa") }

    context "Email doesn't exist" do
      let!(:session_params) { { email: "bbb@gmail.com", password: "bbbbbbb" } }

      it "renders :new template and show error alert" do
        do_request
        expect(flash[:danger]).to eq "Invalid email/password combination"
        expect(response).to render_template :new
      end
    end

    context "Email exist and password incorect" do
      let!(:session_params) { { email: "aaa@gmail.com", password: "bbbbbbb" } }

      it "renders :new template and show error alert" do
        do_request
        expect(flash[:danger]).to eq "Invalid email/password combination"
        expect(response).to render_template :new
      end
    end

    context "Email exist and password correct" do
      let!(:session_params) { { email: "aaa@gmail.com", password: "aaaaaa" } }

      it "rendirect to profile page and show alert" do
        do_request
        expect(flash[:success]).to eq "Welcome to Golden Blog"
        flash[:success] = "Welcome to Golden Blog"
        expect(current_user.id).to eq user.id
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end
  end

  describe "#destroy" do
    def do_request
      delete :destroy
    end

    context "Already logged" do
      let!(:user) { create(:user) }

      before { log_in(user) }

      it "logout and redirect to root path" do
        do_request
        expect(response).to redirect_to root_path
      end
    end

    context "Haven't logged yet" do
      it "redirect to root path" do
        do_request
        expect(response).to redirect_to root_path
      end
    end
  end
end
