require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/index" do
  include PagesHelper
  
  before(:each) do
    @page1 = mock_model(Page, :title => "Titel 1")
    @page2 = mock_model(Page, :title => "Titel 2")
    @pages = [@page1, @page2]
    assigns[:pages] = @pages
    assigns[:categories] = []
    render "/pages/index"
  end

  it "should render list of pages" do
    response.should render_template("/pages/index")
  end
  
  it "should have an unorderded list" do
    response.should have_tag("ul#pages")
  end
  
  it "should have two list elements" do
    response.should have_tag("ul#pages li", :count => 2)
  end
  
  it "should show a link to the pages" do
    @pages.each do |page|
      response.should have_tag("li a[href=#{page_path(page)}]", :text => page.title)
    end
  end
  
  it "should have a link to a new page" do
    response.should have_tag("a[href=?]", new_page_path, :text => "Neue Seite")
  end
  
end
