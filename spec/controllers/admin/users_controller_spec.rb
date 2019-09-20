require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user_admin) { create(:user, role: :admin) }
  describe "#index" do
    def do_request
      get :index
    end

    let!(:user_1) { create(:user) }
    let!(:user_2) { create(:user) }

    before { log_in(user_admin) }

    it "renders :index template and sort by create_at" do
      do_request
      expect(assigns(:users)).to eq [user_2, user_1, user_admin]
      expect(response).to render_template :index
    end
  end
end
