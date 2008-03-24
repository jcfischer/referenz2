require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/referenz (anonymous)" do

  before(:each) do
    template.stub!(:logged_in?).and_return(false)
    render "/layouts/referenz"
  end

  it "should render correct template" do
    response.should render_template("/layouts/referenz")
  end
  
  it "should show the title of the application" do
    response.should have_tag("#header h1", :text => "Referenz")
  end
  
  it "should show the login link" do
    response.should have_tag("#login a[href=?]", "/login", :text => "Login")
  end
  
  it "should show the signup link" do
    response.should have_tag("#login a[href=?]", "/signup", :text => "Registrieren")
  end
  
end

describe "/layouts/referenz (logged in)" do

  
  before(:each) do
    @user = mock_model(User, :login => "Joe Doe")
    template.stub!(:current_user).and_return(@user)
    template.stub!(:logged_in?).and_return(true)
    render "/layouts/referenz"
  end

  it "should show the login link" do
    response.should have_tag("#login a[href=?]", "/logout", :text => "Logout Joe Doe")
  end
  
  it "should have a search form" do
    response.should have_tag("form[action=/search]") do |f|
      f.should have_tag("input[type=text][id=search]")
    end
  end
  
  
end