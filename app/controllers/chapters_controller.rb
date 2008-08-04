class ChaptersController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show]
  
  make_resourceful do
    actions :index, :show
    
  end
  
end
