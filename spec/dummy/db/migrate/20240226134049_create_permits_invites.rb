class CreatePermitsInvites < ActiveRecord::Migration[7.1]
  def change
    create_table :permits_invites, id: :uuid do |t|
      t.references :invited_by, polymorphic: true, index: true, type: :uuid, null: false
      t.references :invitee, polymorphic: true, index: true, type: :uuid, null: true
      t.string :email, null: false
      t.string :aasm_state, null: false
      t.string :slug, null: false
      t.datetime :started_at
      t.datetime :ended_at
      t.timestamps
    end
  end
end
