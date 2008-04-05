class MoveContents < ActiveRecord::Migration
  def self.up
    Content.find(:all).each do |c|

      p c.type_before_type_cast
      case c.type_before_type_cast
      when "Page"
        p = Page.create(:old_id => c.id, :title => c.title, :body => c.body, :category_id => c.category_id, :user_id => c.user_id, :created_at => c.created_at, :updated_at => c.updated_at)
      when "Comment"
        c = Comment.create(:old_id => c.id, :title => c.title, :body => c.body,  :user_id => c.user_id, :page_id => c.page_id, :parent_id => c.parent_id, :created_at => c.created_at, :updated_at => c.updated_at)
      end
    end
    Comment.find(:all).each do |c|
      p = Page.find_by_old_id(c.page.id)
      c.page = p if p  # Zuordnung zu der richtigen Seite
      parent = Comment.find_by_old_id(c.parent_id)
      c.parent = parent if parent # und dem richtigen Elter
      c.save
    end
  end

  def self.down
    
  end
end
