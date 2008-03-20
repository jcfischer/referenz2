require File.dirname(__FILE__) + '/../spec_helper'

describe Access do
  before(:each) do
    @access = Access.new
  end

  it "should be valid" do
    @access.should be_valid
  end
end
