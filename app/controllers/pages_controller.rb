class PagesController < ApplicationController
  Plugins::LoomioOrg::Plugin::LOOMIO_ORG_PAGES.each { |page| define_method page, ->{} }
  layout 'pages'

  before_action :set_locale_specific_links

  def index
    redirect_to "/dashboard" if current_user.is_logged_in?
  end

  private

  def set_locale_specific_links
    case I18n.locale.to_s
    when 'es'
      @help_link = 'https://loomio.gitbooks.io/manual/content/es/index.html'
      @blog_link = 'http://blog.loomio.org/category/espanol-castellano/'
    else
      @help_link = 'https://help.loomio.org'
      @blog_link = 'https://blog.loomio.org/category/stories'
    end
  end
end
