require File.dirname(__FILE__) + '/../../spec_helper'

describe "/search/index" do
  before(:each) do
    @page = mock_model(Page, :title => "Some title", :body => "content")
    assigns[:results] = [@page]
    render 'search/index'
  end
  
  it "should have a title" do
    response.should have_tag('h1', /Suchresultate/)
  end
  
  it "should show the result list" do
    response.should have_tag("#results ul li", :count => 1)
  end
  
  it "should have a link to the resulting page" do
    response.should have_tag("li a[href=?]", page_path(@page), :text => "Some title")
  end
end
