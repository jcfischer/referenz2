class ChaptersController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :get_chapters
  
  def index
    @chapter = @chapters.first
  end
  
  def show
    nr = params[:id].split("_").first
    @chapter = Chapter.find_by_number(nr)
  end
  
private
  def get_chapters
    @chapters = Chapter.find(:all)
  end

  
end
