require File.dirname(__FILE__) + '/../../spec_helper'

describe "/blas/show.html.erb" do
  include BlasHelper
  
  before do
    @bla = mock_model(Bla)

    assigns[:bla] = @bla
  end

  it "should render attributes in <p>" do
    render "/blas/show"
  end
end

