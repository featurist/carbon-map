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

ActiveRecord::Schema.define(version: 2019_10_21_195951) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'group_group_types', force: :cascade do |t|
    t.bigint 'group_id', null: false
    t.bigint 'group_type_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[group_id], name: 'index_group_group_types_on_group_id'
    t.index %w[group_type_id], name: 'index_group_group_types_on_group_type_id'
  end

  create_table 'group_types', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'group_websites', force: :cascade do |t|
    t.string 'website'
    t.bigint 'group_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[group_id], name: 'index_group_websites_on_group_id'
  end

  create_table 'groups', force: :cascade do |t|
    t.string 'name'
    t.string 'abbreviation'
    t.string 'opening_hours'
    t.string 'contact_name'
    t.string 'contact_email'
    t.string 'contact_phone'
    t.boolean 'gdpr'
    t.boolean 'gdpr_email_verified'
    t.bigint 'owner_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[owner_id], name: 'index_groups_on_owner_id'
  end

  create_table 'initiative_statuses', force: :cascade do |t|
    t.string 'name'
    t.string 'description'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'initiatives', force: :cascade do |t|
    t.string 'name'
    t.string 'summary'
    t.string 'image_url'
    t.integer 'anticipated_carbon_saving'
    t.string 'locality'
    t.string 'location'
    t.string 'alternative_solution_name'
    t.bigint 'lead_group_id', null: false
    t.string 'contact_name'
    t.string 'contact_email'
    t.string 'contact_phone'
    t.string 'partner_groups_role'
    t.bigint 'status_id', null: false
    t.boolean 'gdpr'
    t.boolean 'gdpr_email_verified'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.float 'latitude'
    t.float 'longitude'
    t.index %w[lead_group_id], name: 'index_initiatives_on_lead_group_id'
    t.index %w[status_id], name: 'index_initiatives_on_status_id'
  end

  create_table 'sectors', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'solution_classes', force: :cascade do |t|
    t.string 'name'
    t.bigint 'theme_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[theme_id], name: 'index_solution_classes_on_theme_id'
  end

  create_table 'solution_solution_classes', force: :cascade do |t|
    t.bigint 'solution_id', null: false
    t.bigint 'solution_class_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[solution_class_id],
            name: 'index_solution_solution_classes_on_solution_class_id'
    t.index %w[solution_id],
            name: 'index_solution_solution_classes_on_solution_id'
  end

  create_table 'solutions', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'themes', force: :cascade do |t|
    t.string 'name'
    t.bigint 'sector_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[sector_id], name: 'index_themes_on_sector_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[email], name: 'index_users_on_email', unique: true
    t.index %w[reset_password_token],
            name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'group_group_types', 'group_types'
  add_foreign_key 'group_group_types', 'groups'
  add_foreign_key 'group_websites', 'groups'
  add_foreign_key 'initiatives', 'groups', column: 'lead_group_id'
  add_foreign_key 'initiatives', 'initiative_statuses', column: 'status_id'
  add_foreign_key 'solution_classes', 'themes'
  add_foreign_key 'solution_solution_classes', 'solution_classes'
  add_foreign_key 'solution_solution_classes', 'solutions'
  add_foreign_key 'themes', 'sectors'
end
