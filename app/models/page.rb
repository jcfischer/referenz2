class Page < Content
  belongs_to :category, :counter_cache => true
  has_many :comments

  
  is_indexed :fields => ['created_at', 'title', 'body']
  
end
