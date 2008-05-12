class RemoveOldId < ActiveRecord::Migration
  def self.up
    remove_column :pages, :old_id
  end

  def self.down
    add_column :pages, :old_id, :integer
  end
end
