class ChaptersController < ApplicationController
  layout "referenz"

  skip_before_filter :login_required, :only => [:index, :show]
  before_filter :get_chapters
  
  def index
    @chapter = @chapters.first || Chapter.new(:title => 'Kein Kapitel')
  end
  
  def show
    @chapter = Chapter.find_by_permalink(params[:id])
  end
  
private
  def get_chapters
    @chapters = Chapter.find(:all)
  end

  
end
