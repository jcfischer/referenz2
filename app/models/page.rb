class Page < ActiveRecord::Base
  belongs_to :category, :counter_cache => true
  has_many :comments
  belongs_to :user
  
  acts_as_authorizable

  is_indexed :fields => [ 'created_at', 'title', 'body',
                          {:field => 'title', :sortable => true}],
              :include => [{:association_name => 'user', :field => 'login', :as => 'user_login'}],
              :concatenate => [{:association_name => 'comments', :field => 'body', :as => 'comments'}],
              :delta => true
              
  def to_html
    doc = Maruku.new(self.body)
    doc.to_html
  end
end
