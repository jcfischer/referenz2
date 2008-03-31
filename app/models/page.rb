class Page < Content
  belongs_to :category, :counter_cache => true

  
  is_indexed :fields => ['created_at', 'title', 'body']
  
end
