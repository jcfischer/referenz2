class AddPermalink < ActiveRecord::Migration
  def self.up
    add_column :chapters, :permalink, :string
    add_column :sections, :permalink, :string
  end

  def self.down
    remove_column :sections, :permalink
    remove_column :chapters, :permalink
  end
end
