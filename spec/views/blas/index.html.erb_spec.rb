require File.dirname(__FILE__) + '/../../spec_helper'

describe "/blas/index.html.erb" do
  include BlasHelper
  
  before do
    bla_98 = mock_model(Bla)
    bla_99 = mock_model(Bla)

    assigns[:blas] = [bla_98, bla_99]
  end

  it "should render list of blas" do
    render "/blas/index"
  end
end

