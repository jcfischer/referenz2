class SearchController < ApplicationController

  layout "referenz"

  skip_before_filter :login_required

  def index
    @query = params[:search]
    sort_mode = params[:search_sort] || 'relevance'
    sort_by = sort_mode == 'relevance' ? nil : 'created_at'
    model = params[:search_model] || nil
    @search = Ultrasphinx::Search.new(:query => @query, :per_page => 10, :page => params[:page] || 1,
                                      :sort_mode => sort_mode,:sort_by => sort_by, 
                                      :class_name => model)
    @search.excerpt
    @results = @search.results
  end
end
