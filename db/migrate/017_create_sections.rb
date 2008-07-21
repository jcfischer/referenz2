class CreateSections < ActiveRecord::Migration
  def self.up
    create_table :sections do |t|
      t.string :title
      t.text :body, :intro
      t.float :number
      t.integer :chapter_id
      t.timestamps
    end
  end

  def self.down
    drop_table :sections
  end
end
