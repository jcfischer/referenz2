require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController, "GET index" do

  before(:each) do
    @page = mock_model(Page)
    Page.stub!(:find).with(:all).and_return([@page])
  end

  def do_get
    get :index
  end

  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should assign pages" do
    do_get
    assigns[:pages].should == [@page]
  end

  it "should call the find method of the page class" do
    Page.should_receive(:find).with(:all).and_return([@page])
    do_get
  end

  it "should render the index template" do
    do_get
    response.should render_template("index")
  end


end

describe PagesController, "GET new" do
  
  def do_get
    get :new
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render the new template" do
    do_get
    response.should render_template("new")
  end
end