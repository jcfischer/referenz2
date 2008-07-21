class Admin::ChaptersController < ApplicationController
  
  permit 'system_admin'
  layout 'referenz'
  
  make_resourceful do
    actions :all
  end
  
end
