class CreatePermitsPermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permits_permissions, id: :uuid do |t|
      t.references :owner, polymorphic: true, null: false, type: :uuid
      t.references :resource, polymorphic: true, null: false, type: :uuid
      t.string :permits, null: false

      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end

    add_index :permits_permissions, [:owner_id, :owner_type]
    add_index :permits_permissions, [:resource_id, :resource_type]
    add_index :permits_permissions, [:owner_type, :owner_id, :resource_type, :resource_id]
    add_index :permits_permissions, [:owner_type, :owner_id, :resource_type, :resource_id, :permits]
    add_index :permits_permissions, :started_at
    add_index :permits_permissions, :ended_at
    add_index :permits_permissions, :permits
  end
end
