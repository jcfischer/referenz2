require File.dirname(__FILE__) + '/../spec_helper'

describe ErratasController, "GET index" do

  before(:each) do
    @errata = mock_model(Errata)
    Errata.stub!(:find).and_return([@errata])
  end
  
end