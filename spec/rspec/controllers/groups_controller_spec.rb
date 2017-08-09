require 'rails_helper'
describe GroupsController do

  let(:user) { create :user }
  let(:group) { create :formal_group }

  before do
    sign_in user
    group.create_subscription(kind: :paid, group: group)
  end

  describe 'export' do
    it 'exports paid groups' do
      group.add_admin! user
      get :export, key: group.key
      expect(response.status).to eq 200
      expect(response).to render_template :export
    end

    it 'exports free groups for site admins' do
      user.update(is_admin: true)
      get :export, key: group.key
      expect(response.status).to eq 200
      expect(response).to render_template :export
    end

    it 'does not export free groups' do
      group.subscription.update(kind: :gift)
      group.add_admin! user
      get :export, key: group.key
      expect(response).to redirect_to dashboard_path
      expect(flash[:error]).to be_present
    end

    it 'does not export for group members' do
      group.add_member! user
      get :export, key: group.key
      expect(response).to redirect_to dashboard_path
      expect(flash[:error]).to be_present
    end
  end
end
