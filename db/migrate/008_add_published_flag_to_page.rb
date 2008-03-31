class AddPublishedFlagToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :published, :boolean
  end

  def self.down
    remove_column :pages, :published
  end
end
