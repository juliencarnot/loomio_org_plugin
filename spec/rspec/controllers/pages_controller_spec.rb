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
