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

class CreateDatabase < ActiveRecord::Migration
  def self.up
    # insert schema.rb here
    create_table "attendance", id: false, force: true do |t|
      t.integer   "contact_id",                                         default: 0, null: false
      t.integer   "event_id",                                           default: 0, null: false
      t.decimal   "paid",                      precision: 10, scale: 2
      t.string    "sponsor_school", limit: 60
      t.timestamp "last_update",                                                    null: false
    end

    add_index "attendance", ["event_id"], name: "event_id", using: :btree
    add_index "attendance", ["sponsor_school"], name: "sponsor_school", using: :btree

    create_table "contacts", force: true do |t|
      t.string    "last",            limit: 60
      t.string    "first",           limit: 60
      t.string    "role",            limit: 46,  default: "Not Specified"
      t.text      "title"
      t.integer   "school_id"
      t.integer   "eventbrite_id"
      t.string    "work_phone",      limit: 80
      t.string    "email_primary",   limit: 120
      t.string    "email_secondary", limit: 120
      t.text      "notes"
      t.string    "subject_area",    limit: 22,  default: "Not Specified"
      t.string    "other_subject",   limit: 60
      t.string    "gPK",             limit: 3,   default: "No"
      t.string    "gK",              limit: 3,   default: "No"
      t.string    "g01",             limit: 3,   default: "No"
      t.string    "g02",             limit: 3,   default: "No"
      t.string    "g03",             limit: 3,   default: "No"
      t.string    "g04",             limit: 3,   default: "No"
      t.string    "g05",             limit: 3,   default: "No"
      t.string    "g06",             limit: 3,   default: "No"
      t.string    "g07",             limit: 3,   default: "No"
      t.string    "g08",             limit: 3,   default: "No"
      t.string    "g09",             limit: 3,   default: "No"
      t.string    "g10",             limit: 3,   default: "No"
      t.string    "g11",             limit: 3,   default: "No"
      t.string    "g12",             limit: 3,   default: "No"
      t.string    "status",          limit: 8,   default: "Active"
      t.string    "subscribed",      limit: 3,   default: "Yes"
      t.timestamps
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
      t.string    "eventbrite_id", limit: 25
      t.string    "event_name",    limit: 80
      t.string    "event_type",    limit: 40
      t.string    "series",        limit: 80
      t.date      "start_date"
      t.date      "end_date"
      t.string    "venue",         limit: 60
      t.text      "url"
      t.text      "description"
      t.text      "notes"
      t.decimal   "num_sessions",             precision: 10, scale: 0
      t.timestamp "last_update",                                       null: false
    end

    add_index "events", ["venue"], name: "event_fk_school", using: :btree

    create_table "membership", id: false, force: true do |t|
      t.integer   "school_id",   null: false
      t.integer   "year",        null: false
      t.timestamp "last_update", null: false
    end

    add_index "membership", ["school_id"], name: "school_id", using: :btree

    create_table "preferred", force: true do |t|
      t.integer   "school_id",   null: false
      t.integer   "contact_id",  null: false
      t.timestamp "last_update", null: false
    end

    add_index "preferred", ["contact_id"], name: "contact_id", using: :btree
    add_index "preferred", ["school_id"], name: "school_id", using: :btree

    create_table "school_alias", id: false, force: true do |t|
      t.integer "school_id",                         null: false
      t.string  "alias",     limit: 60, default: "", null: false
    end

    create_table "schools", force: true do |t|
      t.string    "name",          limit: 60,                    null: false
      t.string    "official_name", limit: 60
      t.string    "website",       limit: 120
      t.string    "office_phone",  limit: 25
      t.string    "fax",           limit: 25
      t.string    "address1",      limit: 80
      t.string    "address2",      limit: 80
      t.string    "city",          limit: 80
      t.string    "state",         limit: 25
      t.string    "zip",           limit: 15
      t.string    "country",       limit: 80
      t.text      "notes"
      t.string    "region",        limit: 19,  default: "Other"
      t.string    "prek",          limit: 3,   default: "No"
      t.string    "elementary",    limit: 3,   default: "No"
      t.string    "middle",        limit: 3,   default: "No"
      t.string    "highschool",    limit: 3,   default: "No"
      t.timestamp "last_update",                                 null: false
    end

    add_index "schools", ["name"], name: "name", unique: true, using: :btree
    
    def self.down
      # drop all the tables if you really need
      # to support migration back to version 0
    end
  end
end
