class Chapter < ActiveRecord::Base
  
  has_many :sections
  use_permalink :title
  
  def ordinal
    number ? "#{number}." : number
  end
  
end
