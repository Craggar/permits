# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_28_131534) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permits_invites", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "invited_by_type", null: false
    t.uuid "invited_by_id", null: false
    t.string "invitee_type"
    t.uuid "invitee_id"
    t.string "email", null: false
    t.string "aasm_state", null: false
    t.string "slug", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invited_by_type", "invited_by_id"], name: "index_permits_invites_on_invited_by"
    t.index ["invitee_type", "invitee_id"], name: "index_permits_invites_on_invitee"
  end

  create_table "permits_permissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "owner_type", null: false
    t.uuid "owner_id", null: false
    t.string "resource_type", null: false
    t.uuid "resource_id", null: false
    t.string "permits", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ended_at"], name: "index_permits_permissions_on_ended_at"
    t.index ["owner_id", "owner_type"], name: "index_permits_permissions_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id", "resource_type", "resource_id", "permits"], name: "idx_on_owner_type_owner_id_resource_type_resource_i_1cc2eacf54"
    t.index ["owner_type", "owner_id", "resource_type", "resource_id"], name: "idx_on_owner_type_owner_id_resource_type_resource_i_c2232b0e78"
    t.index ["owner_type", "owner_id"], name: "index_permits_permissions_on_owner"
    t.index ["permits"], name: "index_permits_permissions_on_permits"
    t.index ["resource_id", "resource_type"], name: "index_permits_permissions_on_resource_id_and_resource_type"
    t.index ["resource_type", "resource_id"], name: "index_permits_permissions_on_resource"
    t.index ["started_at"], name: "index_permits_permissions_on_started_at"
  end

  create_table "timelines_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "actor_type"
    t.uuid "actor_id"
    t.string "resource_type"
    t.uuid "resource_id"
    t.string "event"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_timelines_events_on_actor"
    t.index ["resource_type", "resource_id"], name: "index_timelines_events_on_resource"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
