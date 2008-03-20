require File.dirname(__FILE__) + '/../../spec_helper'

describe "/blas/edit.html.erb" do
  include BlasHelper
  
  before do
    @bla = mock_model(Bla)
    assigns[:bla] = @bla
  end

  it "should render edit form" do
    render "/blas/edit"
    
    response.should have_tag("form[action=#{bla_path(@bla)}][method=post]") do
    end
  end
end


