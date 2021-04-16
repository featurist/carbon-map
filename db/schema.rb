# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_16_134738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "counties", force: :cascade do |t|
    t.string "name"
    t.bigint "region_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["region_id"], name: "index_counties_on_region_id"
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.bigint "county_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["county_id"], name: "index_districts_on_county_id"
  end

  create_table "group_group_types", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "group_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_group_types_on_group_id"
    t.index ["group_type_id"], name: "index_group_group_types_on_group_type_id"
  end

  create_table "group_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "group_websites", force: :cascade do |t|
    t.string "url"
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_group_websites_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "consent_to_share", default: false, null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "initiative_solutions", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "solution_class_id", null: false
    t.bigint "initiative_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["initiative_id"], name: "index_initiative_solutions_on_initiative_id"
    t.index ["solution_class_id"], name: "index_initiative_solutions_on_solution_class_id"
    t.index ["solution_id"], name: "index_initiative_solutions_on_solution_id"
  end

  create_table "initiative_statuses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "initiative_themes", force: :cascade do |t|
    t.bigint "initiative_id", null: false
    t.bigint "theme_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["initiative_id"], name: "index_initiative_themes_on_initiative_id"
    t.index ["theme_id"], name: "index_initiative_themes_on_theme_id"
  end

  create_table "initiative_websites", force: :cascade do |t|
    t.string "url"
    t.bigint "initiative_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["initiative_id"], name: "index_initiative_websites_on_initiative_id"
  end

  create_table "initiatives", force: :cascade do |t|
    t.string "name"
    t.string "description_further_information"
    t.integer "carbon_saving_amount"
    t.bigint "lead_group_id"
    t.string "contact_name"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "partner_groups_role"
    t.bigint "status_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "consent_to_share_email", default: false, null: false
    t.string "postcode"
    t.bigint "parish_id"
    t.string "description_what"
    t.string "description_how"
    t.string "related_initiatives"
    t.string "administrative_notes"
    t.boolean "carbon_saving_anticipated", default: false, null: false
    t.bigint "owner_id"
    t.string "publication_status"
    t.string "carbon_saving_strategy"
    t.boolean "consent_to_share_phone"
    t.index ["lead_group_id"], name: "index_initiatives_on_lead_group_id"
    t.index ["owner_id"], name: "index_initiatives_on_owner_id"
    t.index ["parish_id"], name: "index_initiatives_on_parish_id"
    t.index ["publication_status"], name: "index_initiatives_on_publication_status"
    t.index ["status_id"], name: "index_initiatives_on_status_id"
  end

  create_table "parishes", force: :cascade do |t|
    t.string "name"
    t.bigint "ward_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ward_id"], name: "index_parishes_on_ward_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sectors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "solution_classes", force: :cascade do |t|
    t.string "name"
    t.bigint "theme_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["theme_id"], name: "index_solution_classes_on_theme_id"
  end

  create_table "solution_solution_classes", force: :cascade do |t|
    t.bigint "solution_id", null: false
    t.bigint "solution_class_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["solution_class_id"], name: "index_solution_solution_classes_on_solution_class_id"
    t.index ["solution_id"], name: "index_solution_solution_classes_on_solution_id"
  end

  create_table "solutions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "status", default: 100, null: false
    t.bigint "created_by_id"
    t.bigint "approved_by_id"
    t.index ["approved_by_id"], name: "index_solutions_on_approved_by_id"
    t.index ["created_by_id"], name: "index_solutions_on_created_by_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.bigint "sector_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["sector_id"], name: "index_themes_on_sector_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "role"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "wards", force: :cascade do |t|
    t.string "name"
    t.bigint "district_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district_id"], name: "index_wards_on_district_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "group_group_types", "group_types"
  add_foreign_key "group_group_types", "groups"
  add_foreign_key "group_websites", "groups"
  add_foreign_key "initiative_solutions", "initiatives"
  add_foreign_key "initiative_solutions", "solution_classes"
  add_foreign_key "initiative_solutions", "solutions"
  add_foreign_key "initiative_themes", "initiatives"
  add_foreign_key "initiative_themes", "themes"
  add_foreign_key "initiative_websites", "initiatives"
  add_foreign_key "initiatives", "groups", column: "lead_group_id"
  add_foreign_key "initiatives", "initiative_statuses", column: "status_id"
  add_foreign_key "solution_classes", "themes"
  add_foreign_key "solution_solution_classes", "solution_classes"
  add_foreign_key "solution_solution_classes", "solutions"
  add_foreign_key "themes", "sectors"
end
