module PageMockHelper
  
  def mock_page(options = {})
    page = mock_model(Page, page_attributes.merge(options))
    page
  end
  
  def page_attributes
    {
      :title => "Eine Test Seite",
      :body  => "test inhalt",
      :to_html => "<p>test inhalt</p>",
      :published? => true,
      :comments => [],
      :user => mock_user,
      :created_at => Time.now
    }
  end
  
end