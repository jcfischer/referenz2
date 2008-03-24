class SearchController < ApplicationController

  layout "referenz"

  def index
    @query = params[:search]
    @search = Ultrasphinx::Search.new(:query => @query)
    @search.excerpt
    
    @results = @search.results
  end
end
