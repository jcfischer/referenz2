require File.dirname(__FILE__) + '/../../spec_helper'

describe "/shared/_login (anonymous)" do

  before(:each) do
    template.stub!(:logged_in?).and_return(false)
    render "/shared/_login"
  end
  
  it "should have the login form" do
    response.should have_tag("form[action=?]", session_path) do |form|
      form.should have_tag("input[name=login]")
      form.should have_tag("input[name=password]")
    end
  end
  
  it "should render correct template" do
    response.should render_template("/shared/_login")
  end
  
  it "should show the signup link" do
    response.should have_tag("#login_box a[href=?]", "/signup", :text => "Registrieren")
  end
  
end

describe "/shared/_login (logged in)" do
  
  before(:each) do
    @user = mock_model(User, :login => "Joe Doe")
    template.stub!(:current_user).and_return(@user)
    template.stub!(:logged_in?).and_return(true)
    render "/shared/_login"
  end

  it "should show the logout link" do
    response.should have_tag("#login_box a[href=?]", "/logout", :text => "Logout Joe Doe")
  end
  
end