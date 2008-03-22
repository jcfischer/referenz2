steps_for :webrat do
  
  When "visiting '$link'" do |link|
    visits link
  end
  
  When "clicks on '$link'" do |link|
    clicks_link link
  end
  
  When "clicks GET '$link'" do |link|
    clicks_get_link link
  end
  
  When "clicks DELETE '$link'" do |link|
    clicks_delete_link link
  end
  
  When "clicks POST '$link'" do |link|
    clicks_post_link link
  end
  
  When "clicks PUT '$link'" do |link|
    clicks_put_link link
  end
  
  When "fills in '$name' with '$value'" do |name, value|
    fills_in name, :with => value
  end
  
  When "selects '$value'" do |value|
    selects value
  end
  
  When "selects '$value' from '$field" do |value, field|
    selects value, :from => field
  end
  
  When "checks '$field'" do |field|
    checks field
  end

  When "unchecks '$field'" do |field|
    unchecks field
  end  
  When "clicks button '$button'" do |button|
    clicks_button button
  end
  
end