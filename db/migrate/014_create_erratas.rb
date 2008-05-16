class CreateErratas < ActiveRecord::Migration
  def self.up
    create_table :erratas do |t|
      t.integer :user_id
      t.string :title, :page
      t.text :description
      t.column :state, :string, :null => :no, :default => 'new'
      t.timestamps
    end
  end

  def self.down
    drop_table :erratas
  end
end
