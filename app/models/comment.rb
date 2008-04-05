class Comment < ActiveRecord::Base
  belongs_to :page
  belongs_to :user
  acts_as_tree :order => "created_at"
  
  
  is_indexed :fields => [
                  'created_at', 
                  'title', 
                  'body'
  
              ],
              :include => [{:association_name => 'user', :field => 'login', :as => 'user_login'}],
              :delta => true
  
  
  def to_html
    doc = Maruku.new(self.body)
    doc.to_html
  end
end
