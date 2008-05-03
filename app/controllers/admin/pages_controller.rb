class Admin::PagesController < ApplicationController

  permit 'system_admin'
  
  layout 'referenz'
  make_resourceful do
    actions :index, :show, :destroy

  end

  def delete_many
    ids = params[:page]
    ids.each do |id|
      begin
        Page.delete id
        # Comment.destroy id
      rescue
        # comment was already destroyed through dependecy
      end
    end
    redirect_to admin_pages_path
  end

  protected
  def current_objects
    Page.paginate(:all, :order => 'title', :page => params[:page], :per_page => 15)
  end


end
