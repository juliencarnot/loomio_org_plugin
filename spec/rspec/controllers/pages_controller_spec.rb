require 'rails_helper'

describe PagesController, type: :controller do
  let(:spanish_user) { create(:user, selected_locale: :es) }

  describe 'marketing' do
    it 'takes you to the marketing page when logged out' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template :index
    end

    it 'takes you to the marketing page when logged in' do
      sign_in create(:user)
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template :index
    end
  end

  describe 'pages' do
    Plugins::LoomioOrg::Plugin::LOOMIO_ORG_PAGES.each do |page|
      let(:user) { create :user }
      let(:group) { create :formal_group }
      let(:guest_group) { create :guest_group }

      it "renders /#{page} for logged out users" do
        get page
        expect(response.status).to eq 200
        expect(response).to render_template page
      end

      it "renders /#{page} for logged in users" do
        group.add_member! user
        guest_group.add_member! user
        sign_in user
        get page
        expect(response.status).to eq 200
        expect(response).to render_template page
      end
    end
  end

  describe 'about' do
    it 'takes you to the about page' do
      get :about
      expect(response.status).to eq 200
      expect(response).to render_template :about
    end

    it 'sets the help links correctly' do
      sign_in spanish_user
      get :about
      expect(assigns(:help_link)).to eq 'https://loomio.gitbooks.io/manual/content/es/index.html'
    end
  end
end
