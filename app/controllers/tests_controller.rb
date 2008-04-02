class TestsController < ApplicationController

  # skip_before_filter :login_required, :only => [:index, :show]

  def index
    respond_to do |format|

      format.html { render :text => "html"}# rendert new.html.haml
      format.js  { render :text => "js"}

    end
  end


end
