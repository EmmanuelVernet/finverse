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

ActiveRecord::Schema[8.1].define(version: 2026_04_06_164448) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.customers", force: :cascade do |t|
    t.string "company_name"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "customer_type"
    t.string "email"
    t.string "legal_name"
    t.integer "onboarding_status"
    t.string "registration_number"
    t.integer "risk_score"
    t.datetime "updated_at", null: false
  end

  create_table "public.onboarding_applications", force: :cascade do |t|
    t.string "application_type", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.boolean "documents_verified", default: false, null: false
    t.text "rejection_reason"
    t.datetime "reviewed_at"
    t.bigint "reviewed_by_id"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_onboarding_applications_on_customer_id"
    t.index ["reviewed_by_id"], name: "index_onboarding_applications_on_reviewed_by_id"
  end

  create_table "public.users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "public.onboarding_applications", "public.customers"
  add_foreign_key "public.onboarding_applications", "public.users", column: "reviewed_by_id"

end
