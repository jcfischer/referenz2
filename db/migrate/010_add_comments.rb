class AddComments < ActiveRecord::Migration
  def self.up
    create_table :pages, :force => true do |t|
      t.string :title
      t.text :body
      t.integer :category_id, :user_id
      t.integer :old_id
      t.boolean :published
      t.timestamps
    end
    create_table :comments, :force => true do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.boolean :published
      t.integer :parent_id, :page_id
      t.integer :old_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
    drop_table :comments
  end
end
