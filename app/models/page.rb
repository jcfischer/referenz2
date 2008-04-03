class Page < Content
  belongs_to :category, :counter_cache => true
  has_many :comments

  
  
end
