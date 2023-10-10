class CreatePermitPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permits_permissions, id: :uuid do |t|
      t.string :owner_id, null: false
      t.string :owner_type, null: false
      t.string :resource_id, null: false
      t.string :resource_type, null: false
      t.string :permits, null: false

      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end

    add_index :permits_permissions, [:owner_id, :owner_type]
    add_index :permits_permissions, [:resource_id, :resource_type]
  end
end
