require 'rails_helper'

describe RootController, type: :controller do

  describe 'index' do
    it 'takes you to the dashboard when logged in' do
      sign_in create(:user)
      get :index
      expect(response).to redirect_to dashboard_path
    end
  end
end
