class SearchController < ApplicationController

  layout "referenz"

  def index

    @search = Ultrasphinx::Search.new(:query => params[:search])
    @search.run
    @results = @search.results
  end
end
