require File.dirname(__FILE__) + '/../../spec_helper'

describe "/layouts/referenz (anonymous)" do

  before(:each) do
    template.stub!(:logged_in?).and_return(false)
    
    template.expect_render(:partial => 'shared/navigation')
    render "/layouts/referenz"
  end

  it "should render correct template" do
    response.should render_template("/layouts/referenz")
  end
  
  it "should show the title of the application" do
    response.should have_tag("#header h1", :text => "Rails-Praxis")
  end
  
end

describe "/layouts/referenz (logged in)" do

  
  before(:each) do
    @user = mock_model(User, :login => "Joe Doe")
    template.stub!(:current_user).and_return(@user)
    template.stub!(:logged_in?).and_return(true)
    render "/layouts/referenz"
  end

  it "should have a search form" do
    response.should have_tag("form[action=/search]") do |f|
      f.should have_tag("input[type=text][id=search]")
    end
  end
  
  
end