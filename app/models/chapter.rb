class Chapter < ActiveRecord::Base
  
  has_many :sections
  
  def ordinal
    number ? "#{number}." : number
  end
  
  def to_param
    "#{number}_#{slug}"
  end
  
  def slug
    return '' if title.blank?
    slug = title.downcase.gsub(/\s/, '_')
    slug.gsub(/![a-z]/, "")
    
  end
  
end
