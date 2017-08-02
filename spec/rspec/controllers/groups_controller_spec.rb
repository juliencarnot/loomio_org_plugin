require 'rails_helper'
describe API::GroupsController do

  let(:user) { create :user }
  let(:group) { create :formal_group, subscription: build(:subscription) }

  before do
    group.admins << user
    sign_in user
  end

  describe 'use_gift_subscription' do
    it 'creates a gift subscription for the group' do
      post :use_gift_subscription, id: group.key
      group_json = JSON.parse(response.body)['groups'][0]
      expect(group_json['subscription_kind']).to eq 'gift'
    end
  end
end
