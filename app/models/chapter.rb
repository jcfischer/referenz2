class Chapter < ActiveRecord::Base
  
  has_many :sections
  
  def ordinal
    number ? "#{number}." : number
  end
  
end
