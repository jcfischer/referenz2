class Comment < Content
  belongs_to :page
  acts_as_tree :order => "created_at"
end
