class CreateNewRoles < ActiveRecord::Migration

  def self.up
    rename_table :roles, :old_roles
    create_table :roles_users, :id => false, :force => true  do |t|
      t.integer :user_id, :role_id
      t.timestamps
    end

    create_table :roles, :force => true do |t|
      t.string  :name, :authorizable_type, :limit => 40
      t.integer :authorizable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_users
    rename_table :old_roles, :roles
  end

end
