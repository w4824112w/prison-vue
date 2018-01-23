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

ActiveRecord::Schema.define(version: 20170728032631) do

  create_table "account_details", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "accounts_id"
    t.decimal "amount", precision: 5, scale: 2
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prisoner_id"
    t.decimal "balance", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "api_keys", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "family_id"
    t.index ["access_token"], name: "access_token_UNIQUE", unique: true
  end

  create_table "app_loggers", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "phone", limit: 13
    t.text "contents", limit: 16777215
    t.string "device_name", limit: 25
    t.string "sys_version", limit: 25
    t.string "device_type", limit: 15
    t.string "app_version", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
  end

  create_table "comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "mail_box_id"
    t.string "contents"
    t.integer "family_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configurations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "jail_id"
    t.json "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jail_id"], name: "config_to_jail_FOREIGN_idx"
  end

  create_table "drawbacks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "family_id"
    t.decimal "figure", precision: 9, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
  end

  create_table "families", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prisoner_id"
    t.string "name"
    t.string "uuid", null: false
    t.string "phone", null: false
    t.string "relationship"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_url"
    t.decimal "balance", precision: 7, scale: 2, default: "0.0"
    t.string "last_trade_no"
    t.integer "sys_flag", default: 1, null: false
    t.index ["uuid", "phone"], name: "phone_uuid"
  end

  create_table "feedbacks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "content"
    t.integer "family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "description"
    t.decimal "price", precision: 7, scale: 2
    t.integer "jail_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "barcode", limit: 32
    t.string "unit", limit: 16
    t.string "factory", limit: 100
    t.integer "ranking", limit: 2, default: 0
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "avatar_url", limit: 1
    t.integer "sys_flag", default: 1, null: false
    t.index ["category_id"], name: "items_to_cate_FOREIGN_idx"
    t.index ["jail_id", "category_id"], name: "items_to_jail_FOREIGN_idx"
  end

  create_table "jails", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title", limit: 50
    t.string "description"
    t.string "street", limit: 50
    t.string "district", limit: 50
    t.string "city", limit: 50
    t.string "state", limit: 50
    t.string "zipcode", limit: 6
    t.string "accid", limit: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["id"], name: "id_UNIQUE", unique: true
  end

  create_table "laws", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "contents", limit: 16777215
    t.integer "jail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.string "image_url", limit: 45
    t.integer "sys_flag", default: 1
    t.index ["jail_id"], name: "laws_to_jail_FOREIGN_idx"
  end

  create_table "line_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "item_id"
    t.integer "order_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "items_to_item_idx"
  end

  create_table "mail_boxes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "contents"
    t.integer "jail_id"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "family_id"
    t.integer "sys_flag", default: 1, null: false
  end

  create_table "meetings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "terminal_id"
    t.integer "family_id"
    t.string "application_date"
    t.string "status", default: "PENDING"
    t.string "meeting_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remarks"
  end

  create_table "news", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.text "contents", limit: 16777215
    t.boolean "is_focus"
    t.integer "jail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.integer "type_id", limit: 1
    t.string "image_url", limit: 45
    t.integer "sys_flag", default: 1
    t.index ["jail_id"], name: "news_to_jail_FOREIGN_idx"
  end

  create_table "news_comments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "content"
    t.integer "family_id"
    t.integer "news_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "trade_no"
    t.integer "jail_id"
    t.string "payment_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "gmt_payment"
    t.string "datetime"
    t.integer "family_id"
    t.string "ip"
    t.index ["jail_id"], name: "orders_to_jail_FOREIGN_idx"
    t.index ["trade_no"], name: "trade_no_UNIQUE", unique: true
  end

  create_table "prison_terms", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "term_start"
    t.string "term_finish"
    t.integer "prisoner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prisoner_order_details", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "prisoner_orders_id"
    t.integer "prisoner_id"
    t.string "goods_name"
    t.decimal "goods_price", precision: 10, scale: 2
    t.string "goods_details"
    t.integer "goods_num"
  end

  create_table "prisoner_orders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "trade_no"
    t.integer "jail_id"
    t.string "payment_type"
    t.string "status"
    t.string "ifreceive"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "family_id"
    t.string "order_details"
    t.integer "total"
  end

  create_table "prisoners", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "prisoner_number"
    t.string "name"
    t.string "gender"
    t.string "crimes"
    t.integer "jail_id"
    t.date "prison_term_started_at"
    t.date "prison_term_ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prison_area"
    t.integer "sys_flag", default: 1, null: false
    t.index ["prisoner_number"], name: "prisoner_number_UNIQUE", unique: true
  end

  create_table "registrations", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "jail_id"
    t.string "name"
    t.string "phone"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "prisoner_number"
    t.string "relationship"
    t.string "status", default: "PENDING"
    t.string "remarks"
    t.string "gender"
  end

  create_table "short_messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "phone"
    t.string "uuid"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "msg"
  end

  create_table "terminals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "jail_id"
    t.string "terminal_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jail_id"], name: "terminals_to_jail_idx"
    t.index ["terminal_number"], name: "terminal_number_UNIQUE", unique: true
  end

  create_table "types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "notices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "salt"
    t.string "hashed_password"
    t.integer "role"
    t.integer "jail_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "username", unique: true
  end

  create_table "uuid_images", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "registration_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "versions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "version_code", limit: 6
    t.integer "version_number", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "type_id", limit: 1, comment: "1表示家属端，2表示监狱端"
    t.string "description"
    t.string "download"
    t.boolean "is_force", default: true
  end

  add_foreign_key "configurations", "jails", name: "config_to_jail_FOREIGN", on_delete: :cascade
  add_foreign_key "items", "categories", name: "items_to_cate_FOREIGN", on_delete: :cascade
  add_foreign_key "items", "jails", name: "items_to_jails_FOREIGN", on_delete: :cascade
  add_foreign_key "laws", "jails", name: "laws_to_jail_FOREIGN", on_delete: :cascade
  add_foreign_key "news", "jails", name: "news_to_jail_FOREIGN", on_delete: :cascade
  add_foreign_key "orders", "jails", name: "orders_to_jail_FOREIGN", on_delete: :cascade
  add_foreign_key "terminals", "jails", name: "terminals_to_jail", on_delete: :cascade
end
