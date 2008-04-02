class Admin::CommentsController < ApplicationController

  layout 'referenz'
  make_resourceful do
    actions :index, :show, :destroy
    belongs_to :page

  end

  def delete_many
    ids = params[:comment]
    ids.each do |id|
      begin
        Comment.delete id
        # Comment.destroy id
      rescue
        # comment was already destroyed through dependecy
      end
    end
    redirect_to admin_comments_path
  end

  protected
  def current_objects
    Comment.paginate(:all, :order => 'created_at', :page => params[:page], :per_page => 15)
  end

end
