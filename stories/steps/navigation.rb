steps_for :navigation do
  
  When "visiting '$link'" do |link|
    get link
    response.should be_success
  end

  Then "$actor should see $template" do |actor, template|
    response.should render_template(template)
  end
  
end