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

ActiveRecord::Schema.define(version: 20160719234622) do

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",      limit: 4,                   null: false
    t.string   "author",       limit: 255,                 null: false
    t.string   "author_url",   limit: 255,                 null: false
    t.string   "author_email", limit: 255,                 null: false
    t.text     "body",         limit: 65535,               null: false
    t.text     "body_html",    limit: 65535,               null: false
    t.datetime "created_at",                 precision: 6
    t.datetime "updated_at",                 precision: 6
  end

  add_index "comments", ["created_at"], name: "index_comments_on_created_at", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "omni_auth_details", force: :cascade do |t|
    t.string   "provider",    limit: 255,                 null: false
    t.string   "uid",         limit: 255
    t.text     "info",        limit: 65535
    t.text     "credentials", limit: 65535
    t.text     "extra",       limit: 65535
    t.datetime "created_at",                precision: 6
    t.datetime "updated_at",                precision: 6
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",      limit: 255,                 null: false
    t.string   "slug",       limit: 255,                 null: false
    t.text     "body",       limit: 65535,               null: false
    t.text     "body_html",  limit: 65535,               null: false
    t.datetime "created_at",               precision: 6
    t.datetime "updated_at",               precision: 6
    t.integer  "user_id",    limit: 4
  end

  add_index "pages", ["created_at"], name: "index_pages_on_created_at", using: :btree
  add_index "pages", ["slug"], name: "pages_slug_unique_idx", using: :btree
  add_index "pages", ["title"], name: "index_pages_on_title", using: :btree
  add_index "pages", ["user_id"], name: "index_pages_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title",                   limit: 255,                                null: false
    t.string   "slug",                    limit: 255,                                null: false
    t.text     "body",                    limit: 65535,                              null: false
    t.text     "body_html",               limit: 65535,                              null: false
    t.boolean  "active",                                              default: true, null: false
    t.integer  "approved_comments_count", limit: 4,                   default: 0,    null: false
    t.datetime "published_at",                          precision: 6
    t.datetime "created_at",                            precision: 6
    t.datetime "updated_at",                            precision: 6
    t.datetime "edited_at",                             precision: 6,                null: false
    t.integer  "user_id",                 limit: 4
  end

  add_index "posts", ["published_at"], name: "index_posts_on_published_at", using: :btree
  add_index "posts", ["slug"], name: "posts_slug_unique_idx", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "pubfiles", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "pfile",       limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              precision: 6, null: false
    t.datetime "updated_at",              precision: 6, null: false
    t.integer  "user_id",     limit: 4
  end

  add_index "pubfiles", ["user_id", "name"], name: "index_pubfiles_on_user_id_and_name", unique: true, using: :btree
  add_index "pubfiles", ["user_id"], name: "index_pubfiles_on_user_id", using: :btree

  create_table "pubimages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "pimage",     limit: 255
    t.datetime "created_at",             precision: 6, null: false
    t.datetime "updated_at",             precision: 6, null: false
    t.integer  "user_id",    limit: 4
  end

  add_index "pubimages", ["user_id", "name"], name: "index_pubimages_on_user_id_and_name", unique: true, using: :btree
  add_index "pubimages", ["user_id"], name: "index_pubimages_on_user_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,                 null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at",               precision: 6
    t.datetime "updated_at",               precision: 6
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.datetime "created_at",                precision: 6
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "taggable_type", limit: 255,               null: false
    t.string   "context",       limit: 128,               null: false
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "undo_items", force: :cascade do |t|
    t.string   "type",       limit: 255,                 null: false
    t.datetime "created_at",               precision: 6, null: false
    t.text     "data",       limit: 65535
    t.integer  "user_id",    limit: 4
  end

  add_index "undo_items", ["created_at"], name: "index_undo_items_on_created_at", using: :btree
  add_index "undo_items", ["user_id"], name: "index_undo_items_on_user_id", using: :btree

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
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
    t.integer  "role",                   limit: 4
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
