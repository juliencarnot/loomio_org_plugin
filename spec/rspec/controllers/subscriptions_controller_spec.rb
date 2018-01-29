require 'rails_helper'

describe SubscriptionsController do

  let(:user) { create :user }
  let(:group) { create :formal_group }
  let(:subscription_params) { {
    subscription: {
      id: group.subscription.id,
      product: {},
      customer: { reference: "#{group.id}-#{Time.now.to_i}" }
    }
  }.with_indifferent_access }

  before { GroupService.create(group: group, actor: user) }

  describe 'webhook' do
    it 'performs a signup_success' do
      post :webhook, params: { payload: subscription_params, event: :signup_success }
      expect(group.subscription.reload.kind).to eq 'paid'
      expect(response.status).to eq 200
    end

    it 'performs a subscription_product_change' do
      subscription_params[:subscription][:product][:handle] = 'test-handle'
      post :webhook, params: { payload: subscription_params, event: :subscription_product_change }
      expect(group.subscription.reload.plan).to eq 'test-handle'
      expect(response.status).to eq 200
    end

    it 'performs a subscription_state_change' do
      subscription_params[:subscription][:state] = 'canceled'
      group.subscription.update kind: :paid
      post :webhook, params: { payload: subscription_params, event: :subscription_state_change }
      expect(group.subscription.reload.kind).to eq 'gift'
      expect(response.status).to eq 200
    end

    it 'responds with bad request if chargify is not set up in-app' do
      SubscriptionService.stub(:available?).and_return(false)
      post :webhook, params: { event: :signup_success }
      expect(response.status).to eq 400
    end
  end

end
