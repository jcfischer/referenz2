require File.dirname(__FILE__) + '/../spec_helper'

describe SearchController do

  describe "GET 'index'" do

    before(:each) do
      controller.stub!(:logged_in?).and_return(true)
      @search = mock("sphinx", :excerpt => true, :results => [])
      Ultrasphinx::Search.stub!(:new).and_return(@search)
    end

    def do_get
      get 'index', :search => "suche"
    end
    
    it "should be successful" do
      do_get
      response.should be_success
    end
    
    it "should call the Ultraspinx search" do
      Ultrasphinx::Search.should_receive(:new).with(:query => "suche", :per_page => 10, :page => 1, :sort_mode => 'relevance', :sort_by => nil, :class_name => nil).and_return(@search)
      do_get
    end
    
    it "should call excerpt method" do
      @search.should_receive(:excerpt)
      do_get
    end
    
    it "should call results method" do
      @search.should_receive(:results).and_return([])
      do_get
    end
    
    it "should assign results" do
      do_get
      assigns[:results].should be_instance_of(Array)
    end
    
    it "should assign the query" do
      do_get
      assigns[:query].should eql("suche")
    end
  end
end
