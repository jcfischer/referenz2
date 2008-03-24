require File.dirname(__FILE__) + '/../spec_helper'

describe Page do
  before(:each) do
    @page = Page.new(:title => "Some Title", :body => "ein Text in **fett**")
  end

  it "should have a to_html method" do
    @page.to_html.should_not be_nil
  end
  
  it "should render markdown" do
    @page.to_html.should match(/<strong>fett<\/strong>/)
  end
end
