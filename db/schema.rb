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

ActiveRecord::Schema[7.1].define(version: 2023_11_30_124039) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "commentator_id"
    t.string "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentator_id"], name: "index_comments_on_commentator_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "contents", force: :cascade do |t|
    t.bigint "post_id"
    t.string "content_type"
    t.string "content_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_contents_on_post_id"
  end

  create_table "followers", force: :cascade do |t|
    t.bigint "follower_user_id"
    t.bigint "following_user_id"
    t.datetime "request_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_user_id"], name: "index_followers_on_follower_user_id"
    t.index ["following_user_id"], name: "index_followers_on_following_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "liked_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["liked_by_user_id"], name: "index_likes_on_liked_by_user_id"
    t.index ["post_id"], name: "index_likes_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "caption"
    t.string "location"
    t.bigint "creator_id"
    t.boolean "is_deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_posts_on_creator_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "tagged_user_id"
    t.bigint "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_tags_on_post_id"
    t.index ["tagged_user_id"], name: "index_tags_on_tagged_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email_id"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users", column: "commentator_id"
  add_foreign_key "contents", "posts"
  add_foreign_key "followers", "users", column: "follower_user_id"
  add_foreign_key "followers", "users", column: "following_user_id"
  add_foreign_key "likes", "posts"
  add_foreign_key "likes", "users", column: "liked_by_user_id"
  add_foreign_key "posts", "users", column: "creator_id"
  add_foreign_key "tags", "posts"
  add_foreign_key "tags", "users", column: "tagged_user_id"
end
