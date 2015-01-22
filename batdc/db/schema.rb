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

ActiveRecord::Schema.define(version: 20150122210152) do

  create_table "attendees", force: true do |t|
    t.integer  "contact_id",                                 default: 0, null: false
    t.integer  "event_id",                                   default: 0, null: false
    t.decimal  "paid",              precision: 10, scale: 2
    t.integer  "sponsor_school_id"
    t.datetime "updated_at",                                             null: false
    t.datetime "created_at"
  end

  add_index "attendees", ["event_id"], name: "event_id", using: :btree
  add_index "attendees", ["sponsor_school_id"], name: "sponsor_school", using: :btree

  create_table "contacts", force: true do |t|
    t.string   "last",            limit: 60
    t.string   "first",           limit: 60
    t.string   "role",            limit: 46,  default: "Not Specified"
    t.text     "title"
    t.integer  "school_id"
    t.integer  "eventbrite_id"
    t.string   "work_phone",      limit: 80
    t.string   "email_primary",   limit: 120
    t.string   "email_secondary", limit: 120
    t.text     "notes"
    t.string   "subject_area",    limit: 22,  default: "Not Specified"
    t.string   "other_subject",   limit: 60
    t.boolean  "gPK",                         default: false
    t.boolean  "gK",                          default: false
    t.boolean  "g01",                         default: false
    t.boolean  "g02",                         default: false
    t.boolean  "g03",                         default: false
    t.boolean  "g04",                         default: false
    t.boolean  "g05",                         default: false
    t.boolean  "g06",                         default: false
    t.boolean  "g07",                         default: false
    t.boolean  "g08",                         default: false
    t.boolean  "g09",                         default: false
    t.boolean  "g10",                         default: false
    t.boolean  "g11",                         default: false
    t.boolean  "g12",                         default: false
    t.string   "status",          limit: 8,   default: "Active"
    t.string   "subscribed",      limit: 3,   default: "Yes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["school_id"], name: "fk_school", using: :btree

  create_table "eventbrite_extra", primary_key: "eventbrite_id", force: true do |t|
    t.text   "last"
    t.text   "first"
    t.text   "title"
    t.text   "school"
    t.string "work_phone",    limit: 80
    t.string "email_primary", limit: 120
    t.text   "website"
    t.string "address1",      limit: 80
    t.string "address2",      limit: 80
    t.string "city",          limit: 80
    t.string "state",         limit: 40
    t.string "zip",           limit: 20
    t.string "country",       limit: 80
  end

  add_index "eventbrite_extra", ["eventbrite_id", "email_primary"], name: "eventbrite_id", unique: true, using: :btree

  create_table "events", force: true do |t|
    t.string   "eventbrite_id", limit: 25
    t.string   "event_name",    limit: 80
    t.string   "event_type",    limit: 40
    t.string   "series",        limit: 80
    t.date     "start_date"
    t.date     "end_date"
    t.string   "venue",         limit: 60
    t.text     "url"
    t.text     "description"
    t.text     "notes"
    t.decimal  "num_sessions",             precision: 10, scale: 0
    t.datetime "updated_at",                                        null: false
    t.datetime "created_at"
  end

  add_index "events", ["venue"], name: "event_fk_school", using: :btree

  create_table "membership", id: false, force: true do |t|
    t.integer  "school_id",  null: false
    t.integer  "year",       null: false
    t.datetime "updated_at", null: false
    t.datetime "created_at"
  end

  add_index "membership", ["school_id"], name: "school_id", using: :btree

  create_table "preferred_contacts", force: true do |t|
    t.integer  "school_id",  null: false
    t.integer  "contact_id", null: false
    t.datetime "updated_at", null: false
    t.datetime "created_at"
  end

  add_index "preferred_contacts", ["contact_id"], name: "contact_id", using: :btree
  add_index "preferred_contacts", ["school_id"], name: "school_id", using: :btree

  create_table "school_alias", id: false, force: true do |t|
    t.integer "school_id",                         null: false
    t.string  "alias",     limit: 60, default: "", null: false
  end

  create_table "schools", force: true do |t|
    t.string   "name",          limit: 60,                    null: false
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
    t.text     "notes"
    t.string   "region",        limit: 19,  default: "Other"
    t.boolean  "prek",                      default: false
    t.boolean  "elementary",                default: false
    t.boolean  "middle",                    default: false
    t.boolean  "highschool",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "latitude",      limit: 24
    t.float    "longitude",     limit: 24
  end

  add_index "schools", ["name"], name: "name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
