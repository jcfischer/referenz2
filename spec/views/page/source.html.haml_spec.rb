require File.dirname(__FILE__) + '/../../spec_helper'

describe "/page/source " do
  include PageControllerHelper

  before(:each) do
  end

  def do_render
    render "/page/source"
  end

  it "should render show template" do
    do_render
    response.should render_template("/page/source")
  end

  it "should have a title field" do
    do_render
    response.should have_tag("h2", "Source Code")
  end


end
