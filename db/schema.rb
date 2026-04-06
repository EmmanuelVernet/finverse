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

ActiveRecord::Schema[8.1].define(version: 2026_04_06_183930) do
  create_schema "extensions"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "graphql.pg_graphql"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "vault.supabase_vault"

  create_table "public.aml_alerts", force: :cascade do |t|
    t.integer "alert_type"
    t.bigint "bank_account_id", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.text "notes"
    t.bigint "reviewed_by_id", null: false
    t.integer "severity"
    t.integer "status"
    t.bigint "triggering_transaction_id", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_aml_alerts_on_bank_account_id"
    t.index ["customer_id"], name: "index_aml_alerts_on_customer_id"
    t.index ["reviewed_by_id"], name: "index_aml_alerts_on_reviewed_by_id"
    t.index ["triggering_transaction_id"], name: "index_aml_alerts_on_triggering_transaction_id"
  end

  create_table "public.bank_accounts", force: :cascade do |t|
    t.string "account_number", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.decimal "current_balance", precision: 15, scale: 2, default: "0.0", null: false
    t.bigint "customer_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_bank_accounts_on_customer_id"
  end

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

  create_table "public.documents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "document_type", null: false
    t.string "file_url", null: false
    t.bigint "onboarding_application_id", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index ["onboarding_application_id"], name: "index_documents_on_onboarding_application_id"
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

  create_table "public.transactions", force: :cascade do |t|
    t.decimal "amount", precision: 15, scale: 2, null: false
    t.bigint "bank_account_id", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.integer "status", default: 0, null: false
    t.integer "transaction_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_transactions_on_bank_account_id"
  end

  create_table "public.users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "role"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "public.aml_alerts", "public.bank_accounts"
  add_foreign_key "public.aml_alerts", "public.customers"
  add_foreign_key "public.aml_alerts", "public.transactions", column: "triggering_transaction_id"
  add_foreign_key "public.aml_alerts", "public.users", column: "reviewed_by_id"
  add_foreign_key "public.bank_accounts", "public.customers"
  add_foreign_key "public.documents", "public.onboarding_applications"
  add_foreign_key "public.onboarding_applications", "public.customers"
  add_foreign_key "public.onboarding_applications", "public.users", column: "reviewed_by_id"
  add_foreign_key "public.transactions", "public.bank_accounts"

end
