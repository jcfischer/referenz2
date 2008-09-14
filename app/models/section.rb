class Section < ActiveRecord::Base
  
  belongs_to :chapter
  
  def ordinal
    number ? "#{number}." : number
  end
  
  def to_param
    "#{slug}"
  end
  
  def slug
    return '' if title.blank?
    slug = title.downcase.gsub(/\s/, '_')
  end
  
end
