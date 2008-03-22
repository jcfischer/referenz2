# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  
    
  helper :all # include all helpers, all the time
  

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd1d217dc4b4b545506b249bc911c6e7d'
  
  filter_parameter_logging :password, :password_confirmation
  

    
  rescue_from ActiveRecord::RecordNotFound, :with => :show_404

  def show_404
    render :file => 'public/404.html', :status => 404
  end
    
end
