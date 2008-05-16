require File.dirname(__FILE__) + '/../spec_helper'

describe ErratasController, "GET index" do

  before(:each) do
    @errata = mock_model(Errata)
    Errata.stub!(:find).and_return([@errata])
  end

  def do_get
    get :index
  end



  it "should render the index template" do
    do_get
    response.should render_template("index")
  end
  
end