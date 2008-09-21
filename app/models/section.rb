class Section < ActiveRecord::Base
  
  belongs_to :chapter
  use_permalink :title
  
  def ordinal
    number ? "#{number}." : number
  end
  

  
end
