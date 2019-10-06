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

ActiveRecord::Schema.define(version: 2019_10_05_213108) do
  create_table 'group_group_types', force: :cascade do |t|
    t.integer 'group_id', null: false
    t.integer 'group_type_id', null: false
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
    t.integer 'group_id', null: false
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
    t.integer 'owner_id'
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
    t.integer 'lead_group_id', null: false
    t.string 'contact_name'
    t.string 'contact_email'
    t.string 'contact_phone'
    t.string 'partner_groups_role'
    t.integer 'status_id', null: false
    t.boolean 'gdpr'
    t.boolean 'gdpr_email_verified'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.float 'latitude'
    t.float 'longitude'
    t.index %w[lead_group_id], name: 'index_initiatives_on_lead_group_id'
    t.index %w[status_id], name: 'index_initiatives_on_status_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
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
end
