class UsersController < ApplicationController
  
  layout "referenz"
  skip_before_filter :login_required, :only => [:new, :create, :activate, :activation, :reactivate]
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]

  

  # render new.rhtml
  def new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      @user.register! 
      # self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Vielen Dank für's registrieren. Du bekommst in den nächsten Minuten ein Mail mit einem Aktivierungslink zugestellt."
    else
      render :action => 'new'
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate!
      flash[:notice] = "Aktivierung ist komplett."
    end
    redirect_back_or_default('/')
  end
  
  def reactivate
    @user = User.find_in_state :first, :pending, :conditions => {:login => params[:user][:login]}
    if @user
      @user.reactivate
      flash[:notice] = "Neues Aktivierungsmail versendet"
    else
      flash[:error] = "Dieser Benutzer wurde bereits aktviert"
    end
    render :action => :activation
  end

  def suspend
    @user.suspend!
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  protected
  def find_user
    @user = User.find(params[:id])
  end

end
