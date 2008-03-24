class Page < ActiveRecord::Base
  belongs_to :category, :counter_cache => true
  belongs_to :user
  
  is_indexed :fields => ['created_at', 'title', 'body']
  
  
  def to_html
    doc = Maruku.new(self.body)
    doc.to_html
  end
  
end
