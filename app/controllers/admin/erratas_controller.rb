class Admin::ErratasController < ApplicationController

  permit 'system_admin'

  layout 'referenz'
  make_resourceful do
    actions :index, :show, :destroy
  end

  def delete_many
    ids = params[:errata]
    ids.each do |id|
      begin
        Errata.delete id
      rescue
        nil
      end
    end
    redirect_to admin_erratas_path
  end

  protected
  def current_objects
    Errata.paginate(:all, :order => 'page', :page => params[:page], :per_page => 15)
  end

end
