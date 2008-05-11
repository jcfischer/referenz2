class PageController < ApplicationController

  layout 'referenz'
  skip_before_filter :login_required

  def home
  end

  def about
  end
  
  def source
  end
end
