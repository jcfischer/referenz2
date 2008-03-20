# load so that we may monkeypatch
require 'rails_generator'

Rails::Generator::Commands::Create.class_eval do
  # changes destination extensions for rhtml, html.erb and css templates
  def file_with_haml(relative_source, relative_destination, 
                     file_options = {}, &block)
    css_dir  = 'public/stylesheets/'
    sass_dir = css_dir + 'sass/'
    @filter  = nil
    
    relative_destination.gsub! /\.(rhtml|html(?:.erb)?|css)$/ do |extension|
      case $1
      when 'rhtml', 'html.erb'
        @filter = :rhaml
        '.html.haml'
      when 'html'
        @filter = :haml
        '.html.haml'
      when 'css'
        @filter = :sass
        directory sass_dir
        '.sass'
      end
    end
   
    # use "sass" subdirectory of "stylesheets"   
    relative_destination.gsub!(css_dir, sass_dir) if @filter == :sass

    result = file_without_haml(relative_source, 
                               relative_destination, 
                               file_options, &block)
    @filter = nil
    result
  end
  
  alias_method_chain :file, :haml
  
  # after the template has been rendered, do the conversion!
  def render_file_with_haml(path, options = {}, &block)
    template = render_file_without_haml(path, options, &block)

    case @filter
    when :rhaml
      Haml::HTML.new(template, :rhtml => true).render
    when :haml
      Haml::HTML.new(template).render
    when :sass
      Sass::CSS.new(template).render
    else
      template
    end
  end
  
  alias_method_chain :render_file, :haml
end
