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

ActiveRecord::Schema[8.0].define(version: 2025_10_23_215148) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string "name", null: false
    t.integer "kind", default: 0, null: false
    t.text "bio"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "birth_date"
    t.integer "founded_year"
    t.string "city"
    t.index ["email"], name: "index_authors_on_email", unique: true
    t.index ["kind"], name: "index_authors_on_kind"
  end

  create_table "authorships", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "material_id", null: false
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id", "material_id"], name: "index_authorships_on_author_id_and_material_id", unique: true
    t.index ["author_id"], name: "index_authorships_on_author_id"
    t.index ["material_id"], name: "index_authorships_on_material_id"
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti", unique: true
  end

  create_table "materials", force: :cascade do |t|
    t.string "type", null: false
    t.string "title", null: false
    t.text "description"
    t.date "published_at"
    t.string "isbn"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "archived", default: false, null: false
    t.string "status", default: "draft", null: false
    t.string "doi"
    t.integer "pages"
    t.integer "duration_minutes"
    t.index ["doi"], name: "index_materials_on_doi", unique: true
    t.index ["isbn"], name: "index_materials_on_isbn", unique: true
    t.index ["status"], name: "index_materials_on_status"
    t.index ["title"], name: "index_materials_on_title"
    t.index ["type"], name: "index_materials_on_type"
    t.index ["user_id"], name: "index_materials_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "authorships", "authors"
  add_foreign_key "authorships", "materials"
  add_foreign_key "materials", "users"
end
