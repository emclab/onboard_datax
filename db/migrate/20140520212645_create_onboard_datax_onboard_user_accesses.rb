class CreateOnboardDataxOnboardUserAccesses < ActiveRecord::Migration
  def change
    create_table :onboard_datax_onboard_user_accesses do |t|
      t.integer :project_id
      t.integer :last_updated_by_id
      t.integer :role_definition_id
      t.integer :user_access_id
      t.integer :engine_id
      t.timestamps
      t.integer :release_id
    end
    
    add_index :onboard_datax_onboard_user_accesses, :project_id
    add_index :onboard_datax_onboard_user_accesses, :user_access_id
    add_index :onboard_datax_onboard_user_accesses, :role_definition_id
    add_index :onboard_datax_onboard_user_accesses, :engine_id
    add_index :onboard_datax_onboard_user_accesses, :release_id
  end
end
