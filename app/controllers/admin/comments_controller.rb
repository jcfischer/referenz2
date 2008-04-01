class Admin::CommentsController < ApplicationController
  
  layout 'referenz'
  make_resourceful do
    actions :all
    belongs_to :page

  end
  
end
