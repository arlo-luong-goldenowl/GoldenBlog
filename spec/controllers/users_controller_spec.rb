require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "#new" do
    def do_request
      get :new
    end

    let(:user) { create(:user) }

    context "Already logged" do
      it "redirect to user profile" do
        log_in(user)
        do_request
        expect(flash[:warning]).to eq "You already logged. Please logout if wanna signup new account"
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end

    context "Have not logged yet" do
      it "renders :new template" do
        do_request
        expect(response).to render_template :new
      end
    end
  end

  describe "#create" do
    def do_request
      post :create, params: { user: user_attributes }
    end

    let(:user) { create(:user) }

    context "valid params" do
      let(:user) { build(:user) }
      let(:user_attributes) { {
        email: "qwerty123@email.com",
        name: "abcxyz123",
        password: 'cccdddeeefff999'
      } }
      it "signup new user" do
        do_request
        expect(flash[:success]).to eq "Signup Successful !"
        expect(response).to redirect_to login_path
      end
    end

    context "invalid params" do
      let(:user) { build(:user) }
      let(:user_attributes) { {
        email: "qwerty123$%x.com",
        name: "xxxyyyzzz",
        password: '_&*'
      } }
      it "renders :new template and show error alerts" do
        do_request
        expect(assigns(:user).errors.messages[:password]).to eq ["is too short (minimum is 6 characters)"]
        expect(response).to render_template :new
      end
    end
  end

  describe "#show" do
    def do_request
      get :show, params: { id: user.id }
    end

    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    context "Have not logged yet" do
      it "renders :show template" do
        do_request
        expect(response).to render_template :show
      end
    end

    context "Already logged and match current_user" do
      it "renders :show template" do
        log_in(user)
        do_request
        expect(response).to redirect_to profile_users_path(status: :new)
      end
    end

    context "Already logged and doesnt match current_user" do
      it "renders :show template" do
        log_in(other_user)
        do_request
        expect(response).to render_template :show
      end
    end

    it "render posts" do
      do_request
      expect(assigns(:posts).size).to be <= 9
      expect(response).to render_template :show
    end
  end

  describe "#profile" do
    def do_request
      get :profile, params: { status: "new" }
    end

    let(:user) { create(:user) }

    before do
      log_in(user)
    end

    context "user profile" do
      it "renders :profile template" do
        do_request
        expect(response).to render_template :profile
      end
    end
  end

  describe "#edit" do
    def do_request
      get :edit, params: { id: user.id }
    end

    let(:user) { create(:user) }

    before { log_in(user) }

    it "renders :edit template" do
      do_request
      expect(response).to render_template :edit
    end
  end

  describe "#update" do
    def do_request
      patch :update, params: {
        id: user.id, user: user_updated_attributes
      }
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "valid params" do
      let!(:user_updated_attributes) { {
          name: "Updated name",
          email: "UpdatedName@gmail.com",
          password: user.password
        } }

      it "updates user" do
        do_request
        expect(flash[:success]).to eq "Update profile Successful !"
        expect(response).to redirect_to edit_user_path(assigns[:user])
      end
    end

    context "invalid params" do
      let!(:user_updated_attributes) do
        {
          name: "",
          email: "UpdatedName@gmail.com",
          password: nil,
          no_exist_field: "no_exist_value"
        }
      end

      it "cannot update user" do
        do_request
        expect(response).to render_template :edit
      end
    end
  end

  describe "#change_password" do
    def do_request
      get :change_password
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "Access change password page" do
      it "renders :change_password template" do
        do_request
        expect(response).to render_template :change_password
      end
    end
  end

  describe "#update_password" do
    def do_request
      post :update_password, params: {
        id: user.id, user: user_updated_attributes
      }
    end

    let!(:user) { create(:user) }

    before { log_in(user) }

    context "invalid params or any params be blank" do
      let!(:user_updated_attributes) do
        {
          no_exist_field: "no_exist_value"
        }
      end

      it "Cannot update password for user" do
        do_request
        expect(flash[:danger]).to eq "Can't let any inputs be blank"
        expect(response).to render_template :change_password
      end
    end

    context "old password doesnt match" do
      let!(:user_updated_attributes) do
        {
          old_password: "#{user.password}-100% wrong" ,
          new_password:"987654321",
          new_password_confirmation:"987654321"
        }
      end

      it "Cannot update password for user" do
        do_request
        expect(flash[:danger]).to eq "Old password doesn't match your account's password"
        expect(response).to render_template :change_password
      end
    end

    context "new password doesn't match new password confirmation" do
      let!(:user_updated_attributes) do
        {
          old_password: user.password,
          new_password:"987654321",
          new_password_confirmation:"123456789"
        }
      end

      it "Cannot update password for user" do
        do_request
        expect(flash[:danger]).to eq "New password doesn't match your new password confirmation"
        expect(response).to render_template :change_password
      end
    end

    context "password too short" do
      let!(:user_updated_attributes) do
        {
          old_password: user.password,
          new_password:"111",
          new_password_confirmation:"111"
        }
      end

      it "Cannot update password for user" do
        do_request
        expect(flash[:danger]).to eq "Your new password too short, please try again"
        expect(response).to render_template :change_password
      end
    end

    context "pass all condition" do
      let!(:user_updated_attributes) do
        {
          old_password: user.password,
          new_password:"123456789",
          new_password_confirmation:"123456789"
        }
      end

      it "Update password success" do
        do_request
        expect(flash[:success]).to eq "Change password success"
        expect(response).to render_template :change_password
      end
    end
  end
end
