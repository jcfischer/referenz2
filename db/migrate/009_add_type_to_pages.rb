class AddTypeToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :type, :string
    Page.reset_column_information
    Page.find(:all).each do |page|
      page.type = "Page"
      page.save
    end
    rename_table :pages, :contents
    add_column :contents, :parent_id, :integer
    add_column :contents, :page_id, :integer
  end

  def self.down
    remove_column :contents, :parent_id
    remove_column :contents, :page_id
    rename_table :contents, :pages
    remove_column :pages, :type
  end
end
