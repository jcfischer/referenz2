class Section < ActiveRecord::Base
  
  belongs_to :chapter
  
  def ordinal
    number ? "#{number}." : number
  end
  
end
