class PagesController < ApplicationController
  layout "referenz"
  
  skip_before_filter :login_required # , :only => [:index, :show]
  
  make_resourceful do
    build :all
    
    before :index do
      @categories = Category.find :all
    end
  end
  
  #def index
  #  @pages = Page.find :all
  #  @categories = Category.find :all
  #end
end
