require File.dirname(__FILE__) + '/../spec_helper'

describe BlasController, "#route_for" do

  it "should map { :controller => 'blas', :action => 'index' } to /blas" do
    route_for(:controller => "blas", :action => "index").should == "/blas"
  end
  
  it "should map { :controller => 'blas', :action => 'new' } to /blas/new" do
    route_for(:controller => "blas", :action => "new").should == "/blas/new"
  end
  
  it "should map { :controller => 'blas', :action => 'show', :id => 1 } to /blas/1" do
    route_for(:controller => "blas", :action => "show", :id => 1).should == "/blas/1"
  end
  
  it "should map { :controller => 'blas', :action => 'edit', :id => 1 } to /blas/1/edit" do
    route_for(:controller => "blas", :action => "edit", :id => 1).should == "/blas/1/edit"
  end
  
  it "should map { :controller => 'blas', :action => 'update', :id => 1} to /blas/1" do
    route_for(:controller => "blas", :action => "update", :id => 1).should == "/blas/1"
  end
  
  it "should map { :controller => 'blas', :action => 'destroy', :id => 1} to /blas/1" do
    route_for(:controller => "blas", :action => "destroy", :id => 1).should == "/blas/1"
  end
  
end

describe BlasController, "#params_from" do

  it "should generate params { :controller => 'blas', action => 'index' } from GET /blas" do
    params_from(:get, "/blas").should == {:controller => "blas", :action => "index"}
  end
  
  it "should generate params { :controller => 'blas', action => 'new' } from GET /blas/new" do
    params_from(:get, "/blas/new").should == {:controller => "blas", :action => "new"}
  end
  
  it "should generate params { :controller => 'blas', action => 'create' } from POST /blas" do
    params_from(:post, "/blas").should == {:controller => "blas", :action => "create"}
  end
  
  it "should generate params { :controller => 'blas', action => 'show', id => '1' } from GET /blas/1" do
    params_from(:get, "/blas/1").should == {:controller => "blas", :action => "show", :id => "1"}
  end
  
  it "should generate params { :controller => 'blas', action => 'edit', id => '1' } from GET /blas/1;edit" do
    params_from(:get, "/blas/1/edit").should == {:controller => "blas", :action => "edit", :id => "1"}
  end
  
  it "should generate params { :controller => 'blas', action => 'update', id => '1' } from PUT /blas/1" do
    params_from(:put, "/blas/1").should == {:controller => "blas", :action => "update", :id => "1"}
  end
  
  it "should generate params { :controller => 'blas', action => 'destroy', id => '1' } from DELETE /blas/1" do
    params_from(:delete, "/blas/1").should == {:controller => "blas", :action => "destroy", :id => "1"}
  end
  
end

describe BlasController, "handling GET /blas" do

  before do
    @bla = mock_model(Bla)
    Bla.stub!(:find).and_return([@bla])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all blas" do
    Bla.should_receive(:find).with(:all).and_return([@bla])
    do_get
  end
  
  it "should assign the found blas for the view" do
    do_get
    assigns[:blas].should == [@bla]
  end
end

describe BlasController, "handling GET /blas.xml" do

  before do
    @bla = mock_model(Bla, :to_xml => "XML")
    Bla.stub!(:find).and_return(@bla)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should find all blas" do
    Bla.should_receive(:find).with(:all).and_return([@bla])
    do_get
  end
  
  it "should render the found blas as xml" do
    @bla.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe BlasController, "handling GET /blas/1" do

  before do
    @bla = mock_model(Bla)
    Bla.stub!(:find).and_return(@bla)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render show template" do
    do_get
    response.should render_template('show')
  end
  
  it "should find the bla requested" do
    Bla.should_receive(:find).with("1").and_return(@bla)
    do_get
  end
  
  it "should assign the found bla for the view" do
    do_get
    assigns[:bla].should equal(@bla)
  end
end

describe BlasController, "handling GET /blas/1.xml" do

  before do
    @bla = mock_model(Bla, :to_xml => "XML")
    Bla.stub!(:find).and_return(@bla)
  end
  
  def do_get
    @request.env["HTTP_ACCEPT"] = "application/xml"
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should find the bla requested" do
    Bla.should_receive(:find).with("1").and_return(@bla)
    do_get
  end
  
  it "should render the found bla as xml" do
    @bla.should_receive(:to_xml).and_return("XML")
    do_get
    response.body.should == "XML"
  end
end

describe BlasController, "handling GET /blas/new" do

  before do
    @bla = mock_model(Bla)
    Bla.stub!(:new).and_return(@bla)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render new template" do
    do_get
    response.should render_template('new')
  end
  
  it "should create an new bla" do
    Bla.should_receive(:new).and_return(@bla)
    do_get
  end
  
  it "should not save the new bla" do
    @bla.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new bla for the view" do
    do_get
    assigns[:bla].should equal(@bla)
  end
end

describe BlasController, "handling GET /blas/1/edit" do

  before do
    @bla = mock_model(Bla)
    Bla.stub!(:find).and_return(@bla)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
  it "should render edit template" do
    do_get
    response.should render_template('edit')
  end
  
  it "should find the bla requested" do
    Bla.should_receive(:find).and_return(@bla)
    do_get
  end
  
  it "should assign the found Bla for the view" do
    do_get
    assigns[:bla].should equal(@bla)
  end
end

describe BlasController, "handling POST /blas" do

  before do
    @bla = mock_model(Bla, :to_param => "1")
    Bla.stub!(:new).and_return(@bla)
  end
  
  def post_with_successful_save
    @bla.should_receive(:save).and_return(true)
    post :create, :bla => {}
  end
  
  def post_with_failed_save
    @bla.should_receive(:save).and_return(false)
    post :create, :bla => {}
  end
  
  it "should create a new bla" do
    Bla.should_receive(:new).with({}).and_return(@bla)
    post_with_successful_save
  end

  it "should redirect to the new bla on successful save" do
    post_with_successful_save
    response.should redirect_to(bla_url("1"))
  end

  it "should re-render 'new' on failed save" do
    post_with_failed_save
    response.should render_template('new')
  end
end

describe BlasController, "handling PUT /blas/1" do

  before do
    @bla = mock_model(Bla, :to_param => "1")
    Bla.stub!(:find).and_return(@bla)
  end
  
  def put_with_successful_update
    @bla.should_receive(:update_attributes).and_return(true)
    put :update, :id => "1"
  end
  
  def put_with_failed_update
    @bla.should_receive(:update_attributes).and_return(false)
    put :update, :id => "1"
  end
  
  it "should find the bla requested" do
    Bla.should_receive(:find).with("1").and_return(@bla)
    put_with_successful_update
  end

  it "should update the found bla" do
    put_with_successful_update
    assigns(:bla).should equal(@bla)
  end

  it "should assign the found bla for the view" do
    put_with_successful_update
    assigns(:bla).should equal(@bla)
  end

  it "should redirect to the bla on successful update" do
    put_with_successful_update
    response.should redirect_to(bla_url("1"))
  end

  it "should re-render 'edit' on failed update" do
    put_with_failed_update
    response.should render_template('edit')
  end
end

describe BlasController, "handling DELETE /blas/1" do

  before do
    @bla = mock_model(Bla, :destroy => true)
    Bla.stub!(:find).and_return(@bla)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the bla requested" do
    Bla.should_receive(:find).with("1").and_return(@bla)
    do_delete
  end
  
  it "should call destroy on the found bla" do
    @bla.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the blas list" do
    do_delete
    response.should redirect_to(blas_url)
  end
end
