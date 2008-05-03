class Admin::UsersController < ApplicationController
  
  permit 'system_admin'
  
  layout 'referenz'
  make_resourceful do
    actions :index, :show, :destroy

  end

  def delete_many
    ids = params[:page]
    ids.each do |id|
      begin
        User.delete id
        # Comment.destroy id
      rescue
        # comment was already destroyed through dependecy
      end
    end
    redirect_to admin_users_path
  end

  protected
  def current_objects
    User.paginate(:all, :order => 'login', :page => params[:page], :per_page => 15)
  end
end
