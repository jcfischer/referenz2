class Admin::ErratasController < ApplicationController

  permit 'system_admin'

  layout 'referenz'
  make_resourceful do
    actions :index, :show, :edit, :update, :destroy
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
  
  def publish
    @errata = Errata.find(params[:id])
    @errata.publish!
    redirect_to edit_admin_errata_path(@errata)
  end

  protected
  def current_objects
    Errata.paginate(:all, :order => 'page', :page => params[:page], :per_page => 15)
  end

end
