class Content < ActiveRecord::Base
  belongs_to :user  
  
  
  def to_html
    doc = Maruku.new(self.body)
    doc.to_html
  end
end