require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/show", :shared => true do
  include PagesHelper

  before(:each) do
    @page = mock_page
    assigns[:page] = @page
    assigns[:categories] = []
  end

  def do_render
    render "/pages/show"
  end

  it "should render show template" do
    do_render
    response.should render_template("/pages/show")
  end

  it "should have a title field" do
    do_render
    response.should have_tag("h1", :text => @page.title)
  end

  it "should have a body field" do
    do_render
    response.should have_tag("p", :text => /#{@page.body}/)
  end

end

describe "/pages/show (logged in)" do
  it_should_behave_like '/pages/show'

  before(:each) do
    template.stub!(:logged_in?).and_return(true)
  end

  it "should have a link to edit" do
    do_render
    response.should have_tag("a[href=?]", edit_page_path(@page), :text => "Bearbeiten")
  end

  it "should have a link to leave a comment" do
    pending "noch keine Kommentarklasse" do
      do_render
      response.should have_tag("a[href=?]", new_page_comments_path(@page), :text => "Kommentar schreiben")
    end
  end
end

describe "/pages/show (anonymous)" do

  it_should_behave_like '/pages/show'

  before(:each) do
    template.stub!(:logged_in?).and_return(false)
  end

  it "should have a link to edit" do
    do_render
    response.should_not have_tag("a[href=?]", edit_page_path(@page), :text => "Bearbeiten")
  end

  it "should have a link to register to comment" do
    do_render
    response.should have_tag("a[href=?]", signup_path, :text => "Registrieren um zu kommentieren")
  end
end
