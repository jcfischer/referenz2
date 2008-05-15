class ErratasController < ApplicationController
  layout "referenz"

  make_resourceful do
    actions :index, :show, :new, :create
    
    before :create do
      @errata.user = current_user
    end
    
    response_for :create, :update do |format|
      format.html { redirect_to erratas_path }
    end
    
  end
  
  def current_objects
    Errata.paginate(:all, :order => 'page', :page => params[:page], :per_page => 15)
  end
  
end
