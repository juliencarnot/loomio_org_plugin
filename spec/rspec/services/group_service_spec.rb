require 'rails_helper'

describe 'GroupService' do
  let(:user) { create(:user) }
  let(:group) { build(:formal_group) }

  describe 'create' do
    it 'creates a new gift subscription' do
      GroupService.create(group: group, actor: user)
      subscription = group.reload.subscription
      expect(subscription.kind.to_sym).to eq :gift
    end
  end

  describe 'archive!' do
    it 'cancels the subscription' do
      group.add_admin! user
      instance = OpenStruct.new
      allow(SubscriptionService).to receive(:new).and_return(instance)
      expect(instance).to receive :end_subscription!
      GroupService.archive(group: group, actor: user)
    end
  end
end
