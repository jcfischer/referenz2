# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def ajax_link_to (name, options = {}, html_opt = {})
    classes = 'ajax ' + (html_opt[:class] ? html_opt[:class] : "")
    html_options = {}.merge html_opt
    html_options[:class] = classes
    link_to(name, options, html_options)
  end

end
