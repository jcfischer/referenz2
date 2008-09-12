require File.dirname(__FILE__) + '/../spec_helper'

describe ChaptersController, "GET index" do

  before(:each) do
    @chapter = mock_model(Chapter)
    Chapter.stub!(:find).and_return([@chapter])
  end

  def do_get
    get :index
  end

  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should assign chapters" do
    do_get
    assigns[:chapters].should == [@chapter]
  end

  it "should assign first chapter" do
    do_get
    assigns[:chapter].should == @chapter
  end
  it "should call the find method of the page class" do
    Chapter.should_receive(:find).with(:all).and_return([@chapter])
    do_get
  end

  it "should render the index template" do
    do_get
    response.should render_template("index")
  end
end

describe ChaptersController, "GET show" do

  before(:each) do
    @chapter = mock_model(Chapter, :number => '2')
    Chapter.stub!(:find).and_return([@chapter])
    Chapter.stub!(:find_by_number).and_return(@chapter)
  end

  def do_get
    get :show, :id => '2_einfuhrung'
  end

  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should assign chapters" do
    do_get
    assigns[:chapters].should == [@chapter]
  end

  it "should assign first chapter" do
    do_get
    assigns[:chapter].should == @chapter
  end
  it "should call the find method of the chapter class" do
    Chapter.should_receive(:find).with(:all).and_return([@chapter])
    do_get
  end
  
  it "should call the find method of the chapter class" do
    Chapter.should_receive(:find_by_number).with("2").and_return(@chapter)
    do_get
  end
  

  it "should render the index template" do
    do_get
    response.should render_template("show")
  end
end