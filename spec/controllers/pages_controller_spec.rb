require File.dirname(__FILE__) + '/../spec_helper'

describe PagesController, "GET index" do

  before(:each) do
    @page = mock_model(Page)
    Page.stub!(:find).and_return([@page])
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
    Page.should_receive(:find).with(:all, :order => "title ASC").and_return([@page])
    do_get
  end

  it "should render the index template" do
    do_get
    response.should render_template("index")
  end
end

describe PagesController, "GET show" do
  
  before(:each) do
    @page = mock_model(Page, :title => "Ein Titel", :body => "text in **fett** ")
    Page.stub!(:find).and_return(@page)
  end
  
  def do_get
    get :show, :id => @page.id
  end
  
  it "should be successfull" do
    do_get
    response.should be_success
  end
  
end

describe PagesController, "GET new (logged in)" do
  
  before(:each) do
    controller.stub!(:logged_in?).and_return(true)
  end
  
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

describe PagesController, "GET new (anonymous)" do
  
  before(:each) do
    controller.stub!(:logged_in?).and_return(false)
  end

  it "should be redirect" do
    get :new
    response.should redirect_to("/session/new")
  end 
end

describe PagesController, "POST create (logged in)" do
  
  before(:each) do
    controller.stub!(:logged_in?).and_return(true)
    @page = mock_model(Page, :new_record => true, :save => true)
    Page.stub!(:new).and_return(@page)
  end
  
  def do_post
    post :create, :page => { :title => "some title", :body => "content"}
  end
  
  it "should be redirct" do
    do_post
    response.should be_redirect
  end
  
  it "should render to show" do
    do_post
    response.should redirect_to(page_path(@page))
  end
  
  it "should call save on new page" do
    @page.should_receive(:save).and_return(true)
    do_post
  end
  
end