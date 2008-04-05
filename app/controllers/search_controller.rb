class SearchController < ApplicationController

  layout "referenz"

  def index
    @query = params[:search]
    @search = Ultrasphinx::Search.new(:query => @query, :per_page => 2, :page => params[:page] || 1)
    @search.excerpt
    @results = @search.results
  end
end
