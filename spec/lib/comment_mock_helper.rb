module CommentMockHelper
  
  def mock_comment(options = {})
    comment = mock_model(Comment, comment_attributes.merge(options))
    comment
  end
  
  def comment_attributes
    {
      :title => "Eine Test Seite",
      :body  => "test inhalt",
      :to_html => "<p>test inhalt</p>",
      :published? => true,
      :children => [],
      :created_at => Time.now
    }
  end
end