require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/new" do
  include PagesHelper
  
  before(:each) do
    assigns[:page] = Page.new
    assigns[:categories] = []
    render "/pages/new"
  end

  it "should render new template" do
    response.should render_template("/pages/new")
  end
  
  it "should have a form" do
    response.should have_tag("form")
  end
  
  it "should have a title field" do
    response.should have_tag("input[type=text][id=page_title]")
  end
  
  it "should have a body field" do
    response.should have_tag("textarea[id=page_body]")
  end
  
  it "should have a submit button" do
    response.should have_tag("input[type=submit][value=?]", "Erstellen")
  end
  
  it "should have a link to cancel" do
    response.should have_tag("a[href=?]", pages_path, :text => "Abbrechen")
  end
  
end