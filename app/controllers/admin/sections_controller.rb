class Admin::SectionsController < ApplicationController
  permit 'system_admin'
  layout 'referenz'
  
  make_resourceful do
    actions :all
    belongs_to :chapter
    
    response_for :create, :update do |format|
      format.html { redirect_to admin_chapter_path(@chapter) }
    end
  end
end

