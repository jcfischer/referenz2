class Content < ActiveRecord::Base
  belongs_to :user  
  
  is_indexed :fields => [
                  'created_at', 
                  'title', 
                  'body'
  
              ],
              :include => [{:association_name => 'user', :field => 'login', :as => 'user_login'}],
              :delta => true,
              :conditions => "type = 'Page'"
            


  
  
  def to_html
    doc = Maruku.new(self.body)
    doc.to_html
  end
end