class PagesController < ApplicationController
  layout "referenz"
  
  skip_before_filter :login_required, :only => [:index, :show]
  
  def index
    @pages = Page.find :all
    @categories = Category.find :all
  end
end
