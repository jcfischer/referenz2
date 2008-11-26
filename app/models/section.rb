class Section < ActiveRecord::Base
  
  belongs_to :chapter
  use_permalink :title
  
  is_indexed :fields => [ 'created_at', 'title', 'body',
                          {:field => 'title', :sortable => true}],
              :delta => true

  def ordinal
    number ? "#{number}." : number
  end
  

  
end
