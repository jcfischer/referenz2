require File.dirname(__FILE__) + '/../../spec_helper'

describe "/pages/show", :shared => true do
  include PagesHelper

  before(:each) do
    @comment1 = mock_comment(:title => "Kommentar1")
    @comment2 = mock_comment(:title => "Kommentar2")
    @comments = [@comment1, @comment2]
    @page = mock_page(:comments => @comments )

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
  
  it "should have a div for comments" do
    do_render
    response.should have_tag("div#comments")
  end
  
  it "should show 2 comments" do
    do_render
    response.should have_tag("div#comments ul li", :count => 2)
  end
  
  it "should show the comments" do
    do_render
    @comments.each do |comment|
      response.should have_tag("h3", :text => comment.title)
      response.should have_tag("p", :text => /#{comment.body}/)
    end
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
    do_render
    response.should have_tag("a[href=?]", new_page_comment_path(@page), :text => "Kommentar schreiben")
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
