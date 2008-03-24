steps_for :login do
  
  Given "an anonymous user" do
  end
  
  Given "a user named '$name' with password '$password'" do |name, password|
    user = User.authenticate(name, password)
    unless user
      user = User.create(:login => name, :email => "#{name}@example.com", :password => password, :password_confirmation => password)
      user.register!
      user.activate!
    end
  end
  
  Given "user '$name' logs in with '$password'" do |name, password|
    visits "/login"
    fills_in "login", :with => name
    fills_in "password", :with => password
    clicks_button "Log in"
  end
end