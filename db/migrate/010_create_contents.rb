class CreateContents < ActiveRecord::Migration
  def self.up

    Page.find(:all).each do |page|
      page.type = "Page"
      page.save
    end
    
    rename_table :pages, :contents
    add_column :contents, :parent_id, :integer
  end

  def self.down
    remove_column :contents, :parent_id
    rename_table :contents, :pages

  end
end
