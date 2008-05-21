class ErratasController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show]
  
  make_resourceful do
    actions :index, :show, :new, :create
    
    before :create do
      @errata.user = current_user
    end
    
    response_for :create, :update do |format|
      format.html { redirect_to :action => "thanks" }
    end
    
  end
  
  def thanks
  end
  
  def current_objects
    Errata.paginate(:all, :order => 'page', :page => params[:page], :per_page => 15, :conditions => ["state = ?", "reviewed"])
  end
  
end
