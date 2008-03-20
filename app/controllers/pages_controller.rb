class PagesController < ApplicationController
  layout "referenz"
  def index
    @pages = Page.find :all
    @categories = Category.find :all
  end
end
