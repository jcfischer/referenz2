class Admin::ChaptersController < ApplicationController
  
  permit 'system_admin'
  layout 'referenz'
  
  make_resourceful do
    actions :all
    
  end
  
  def current_object
    nr = params[:id].split("_").first
    Chapter.find_by_number(nr)
  end
end
