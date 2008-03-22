steps_for :navigation do
  
  Then "$actor should see $template" do |actor, template|
    response.should render_template(template)
  end
  
end