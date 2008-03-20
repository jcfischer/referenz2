require File.dirname(__FILE__) + '/../../spec_helper'

describe "/blas/new.html.erb" do
  include BlasHelper
  
  before do
    @bla = mock_model(Bla)
    @bla.stub!(:new_record?).and_return(true)
    assigns[:bla] = @bla
  end

  it "should render new form" do
    render "/blas/new"
    
    response.should have_tag("form[action=?][method=post]", blas_path) do
    end
  end
end


