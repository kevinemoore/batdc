# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150501003734) do

  create_table "attendees", force: :cascade do |t|
    t.integer  "contact_id",        limit: 4,                          default: 0, null: false
    t.integer  "event_id",          limit: 4,                          default: 0, null: false
    t.decimal  "paid",                        precision: 10, scale: 2
    t.integer  "sponsor_school_id", limit: 4
    t.datetime "updated_at",                                                       null: false
    t.datetime "created_at"
  end

  add_index "attendees", ["event_id", "contact_id"], name: "index_attendees_on_event_id_and_contact_id", unique: true, using: :btree
  add_index "attendees", ["event_id"], name: "event_id", using: :btree
  add_index "attendees", ["sponsor_school_id"], name: "sponsor_school", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "last",            limit: 60
    t.string   "first",           limit: 60
    t.string   "role",            limit: 46,    default: "Not Specified"
    t.text     "title",           limit: 65535
    t.integer  "school_id",       limit: 4
    t.integer  "eventbrite_id",   limit: 4
    t.string   "work_phone",      limit: 80
    t.string   "email_primary",   limit: 120
    t.string   "email_secondary", limit: 120
    t.text     "notes",           limit: 65535
    t.string   "subject_area",    limit: 22,    default: "Not Specified"
    t.string   "other_subject",   limit: 60
    t.boolean  "gPK",             limit: 1,     default: false
    t.boolean  "gK",              limit: 1,     default: false
    t.boolean  "g01",             limit: 1,     default: false
    t.boolean  "g02",             limit: 1,     default: false
    t.boolean  "g03",             limit: 1,     default: false
    t.boolean  "g04",             limit: 1,     default: false
    t.boolean  "g05",             limit: 1,     default: false
    t.boolean  "g06",             limit: 1,     default: false
    t.boolean  "g07",             limit: 1,     default: false
    t.boolean  "g08",             limit: 1,     default: false
    t.boolean  "g09",             limit: 1,     default: false
    t.boolean  "g10",             limit: 1,     default: false
    t.boolean  "g11",             limit: 1,     default: false
    t.boolean  "g12",             limit: 1,     default: false
    t.string   "status",          limit: 8,     default: "Active"
    t.string   "subscribed",      limit: 3,     default: "Yes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["school_id"], name: "fk_school", using: :btree

  create_table "eventbrite_extra", primary_key: "eventbrite_id", force: :cascade do |t|
    t.text   "last",          limit: 65535
    t.text   "first",         limit: 65535
    t.text   "title",         limit: 65535
    t.text   "school",        limit: 65535
    t.string "work_phone",    limit: 80
    t.string "email_primary", limit: 120
    t.text   "website",       limit: 65535
    t.string "address1",      limit: 80
    t.string "address2",      limit: 80
    t.string "city",          limit: 80
    t.string "state",         limit: 40
    t.string "zip",           limit: 20
    t.string "country",       limit: 80
  end

  add_index "eventbrite_extra", ["eventbrite_id", "email_primary"], name: "eventbrite_id", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "eventbrite_id", limit: 25
    t.string   "event_name",    limit: 80
    t.string   "event_type",    limit: 40
    t.string   "series",        limit: 80
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "venue",         limit: 60
    t.text     "url",           limit: 65535
    t.text     "description",   limit: 65535
    t.text     "notes",         limit: 65535
    t.decimal  "num_sessions",                precision: 10
    t.datetime "updated_at",                                 null: false
    t.datetime "created_at"
    t.integer  "school_id",     limit: 4
  end

  add_index "events", ["venue"], name: "event_fk_school", using: :btree

  create_table "membership_years", id: false, force: :cascade do |t|
    t.integer  "school_id",  limit: 4, null: false
    t.integer  "year",       limit: 4, null: false
    t.datetime "updated_at",           null: false
    t.datetime "created_at"
  end

  add_index "membership_years", ["school_id"], name: "school_id", using: :btree

  create_table "preferred_contacts", force: :cascade do |t|
    t.integer  "school_id",  limit: 4, null: false
    t.integer  "contact_id", limit: 4, null: false
    t.datetime "updated_at",           null: false
    t.datetime "created_at"
  end

  add_index "preferred_contacts", ["contact_id"], name: "contact_id", using: :btree
  add_index "preferred_contacts", ["school_id"], name: "school_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  create_table "school_alias", id: false, force: :cascade do |t|
    t.integer "school_id", limit: 4,               null: false
    t.string  "alias",     limit: 60, default: "", null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string   "name",          limit: 60,                      null: false
    t.string   "official_name", limit: 60
    t.string   "website",       limit: 120
    t.string   "office_phone",  limit: 25
    t.string   "fax",           limit: 25
    t.string   "address1",      limit: 80
    t.string   "address2",      limit: 80
    t.string   "city",          limit: 80
    t.string   "state",         limit: 25
    t.string   "zip",           limit: 15
    t.string   "country",       limit: 80
    t.text     "notes",         limit: 65535
    t.string   "region",        limit: 19,    default: "Other"
    t.boolean  "prek",          limit: 1,     default: false
    t.boolean  "elementary",    limit: 1,     default: false
    t.boolean  "middle",        limit: 1,     default: false
    t.boolean  "highschool",    limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",      limit: 24
    t.float    "longitude",     limit: 24
  end

  add_index "schools", ["name"], name: "name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
