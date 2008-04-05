require File.dirname(__FILE__) + '/../../spec_helper'

describe "/search/index" do
  before(:each) do
    @page = mock_model(Page, :title => "Some title", :body => "content")
    assigns[:results] =
    @results =  [@page]
    @results.stub!(:page_count).and_return(1)
    assigns[:search] = @results
    assigns[:query] = "suchwort"
    render 'search/index'
  end
  
  it "should have a title" do
    response.should have_tag('h2', /Suchresultate/)
  end
  
  it "should show the result list" do
    response.should have_tag("#results ul li", :count => 1)
  end
  
  it "should have a link to the resulting page" do
    response.should have_tag("li a[href=?]", page_path(@page), :text => "Some title")
  end
  
  it "should show the search query" do
    response.should have_tag("h3", 'suchwort')
  end
  
  it "should show the body field" do
    response.should have_tag("p", "content")
  end
end
