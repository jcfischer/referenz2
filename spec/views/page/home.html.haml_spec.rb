require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page/home", :shared => true do
  include PageControllerHelper

  before(:each) do

  end

  def do_render
    render "/page/home"
  end

  it "should render show template" do
    do_render
    response.should render_template("/page/home")
  end

  it "should have a title field" do
    do_render
    response.should have_tag("h2", :text => 'Referenz')
  end

  it "should have a body field" do
    do_render
    response.should have_tag("h4", :text => /Die Begleitseite zum Buch/)
  end
  
end

describe "/page/home (logged in)" do
  it_should_behave_like '/page/home'

  before(:each) do
    template.stub!(:logged_in?).and_return(true)
    template.stub!(:current_user).and_return(@user)
    
  end

  
  it "should not have a register link" do
    do_render
    response.should_not have_tag("a[href=?]", signup_path, :text => /Registrieren/)
  end
end

describe "/page/home (anonymous)" do

  it_should_behave_like '/page/home'

  before(:each) do
    template.stub!(:logged_in?).and_return(false)
  end

  it "should have a link to register" do
    do_render
    response.should have_tag("a[href=?]", signup_path, :text => /Registrieren/)
  end

end