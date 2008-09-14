class SectionsController < ApplicationController
  
  layout "referenz"

  skip_before_filter :login_required, :only => [:show]
  
  def show
    @chapters = Chapter.find(:all)
    logger.debug params
    title = params[:id]
    @section = Section.find_by_title(title)
  end
  
end
