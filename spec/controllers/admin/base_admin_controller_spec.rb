require 'rails_helper'

RSpec.describe Admin::BaseAdminController, type: :controller do
  it { should use_before_action(:logged_in_user) }
  it { should use_before_action(:check_permission) }
end
