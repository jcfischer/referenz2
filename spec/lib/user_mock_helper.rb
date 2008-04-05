module UserMockHelper
  
  def mock_user(options = {})
    user = mock_model(User, user_attributes.merge(options))
    user
  end
  
  def user_attributes
    {
      :login => "joedou",
      :email => 'joe@example.com',
      :gravatar_img_link => '#',
      :created_at => Time.now
    }
  end
  
end