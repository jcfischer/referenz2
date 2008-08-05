class ChaptersController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show]
  
  make_resourceful do
    actions :index, :show
    before :show do
      @chapters = Chapter.find(:all)
    end
    before :index do
      @chapter = Chapter.find(:first)
    end
  end
  
end
