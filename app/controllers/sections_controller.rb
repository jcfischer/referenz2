class SectionsController < ApplicationController
  
  layout "referenz"

  skip_before_filter :login_required, :only => [:show]
  
  def show
    @chapters = Chapter.find(:all)
    @section = Section.find_by_permalink(params[:id])
    @chapter = @section.chapter
  end
  
end
