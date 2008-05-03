require File.dirname(__FILE__) + '/../../spec_helper'


describe Admin::PagesController, "logged in, regular user" do

  before(:each) do
    controller.stub!(:logged_in?).and_return(true)
    controller.stub!(:current_user).and_return(mock_user(:has_role? => false))
  end

  it "should not allow access" do
    get :index
    response.should be_redirect
  end
end


describe Admin::PagesController, "logged is, system admin" do

  before(:each) do
    controller.stub!(:logged_in?).and_return(true)
    controller.stub!(:current_user).and_return(mock_user(:has_role? => true))
  end

  it "should only allow access to the system_admin" do
    get :index
    response.should be_success
  end
end
