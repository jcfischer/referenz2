class CommentsController < ApplicationController

  # skip_before_filter :login_required, :only => [:index, :show]

  layout 'referenz'
  make_resourceful do
    actions :all
    belongs_to :page

    response_for :new do
      @comment_div = "#comment"
      logger.debug "accepts: #{request.accepts}"
      respond_to do |format|
        format.js  
        format.html 

      end
    end

    response_for :create do
      redirect_to page_path(@page)
    end

    before :new do
      @parent_comment = Comment.find(params['comment_id']) if params['comment_id']
    end

    before :create do
      @comment.user = current_user
      if params['comment_id']
        @comment.parent_id = params['comment_id']
        @comment.page = nil
      end
    end
  end

end
