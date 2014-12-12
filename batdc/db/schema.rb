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

ActiveRecord::Schema.define(version: 0) do

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
    t.string    "school",          limit: 60
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
    t.timestamp "last_update",                                           null: false
    t.timestamp "verified",                                              null: false
  end

  add_index "contacts", ["school"], name: "fk_school", using: :btree

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

  create_table "zzz_blended_learning", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_dept_charis_la", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_educators_of_color", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_la_admin", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_leadership_101", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_lesson_planning_2013", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_membership", id: false, force: true do |t|
    t.string "school",    limit: 120
    t.string "1999_2000", limit: 8
    t.string "2000_2001", limit: 8
    t.string "2001_2002", limit: 8
    t.string "2002_2003", limit: 8
    t.string "2003_2004", limit: 8
    t.string "2004_2005", limit: 8
    t.string "2005_2006", limit: 8
    t.string "2006_2007", limit: 8
    t.string "2007_2008", limit: 8
    t.string "2008_2009", limit: 8
    t.string "2009_2010", limit: 8
    t.string "2010_2011", limit: 8
    t.string "2011_2012", limit: 8
    t.string "2012_2013", limit: 8
  end

  create_table "zzz_science_of_meaningful_life", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_sixth_grade", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

  create_table "zzz_women_ind_schools_2013", id: false, force: true do |t|
    t.string "first",  limit: 120
    t.string "last",   limit: 120
    t.string "email",  limit: 120
    t.string "school", limit: 60
    t.text   "title"
  end

end
