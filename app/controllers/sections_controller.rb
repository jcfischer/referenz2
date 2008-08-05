class SectionsController < ApplicationController
  
  layout "referenz"

  skip_before_filter :login_required, :only => [:show]
  
  make_resourceful do
    actions :show
    
    belongs_to :chapter
    before :show do
      @chapters = Chapter.find(:all)
    end
  end
end
