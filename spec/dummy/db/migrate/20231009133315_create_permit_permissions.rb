class CreatePermitPermissions < ActiveRecord::Migration[7.1]
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
  end
end
