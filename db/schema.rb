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

ActiveRecord::Schema.define(version: 20161115214212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_line_1"
    t.string   "street_line_2"
    t.string   "street_line_3"
    t.string   "country"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.string   "kind"
    t.string   "phone_number"
    t.integer  "row_order"
    t.string   "addressable_type"
    t.integer  "addressable_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", using: :btree
  end

  create_table "bp_custom_fields_abstract_resources", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bp_custom_fields_appearances", force: :cascade do |t|
    t.string   "resource"
    t.string   "resource_id"
    t.boolean  "appears",           default: true
    t.integer  "row_order"
    t.integer  "group_template_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["group_template_id"], name: "bpf_a_gt", using: :btree
  end

  create_table "bp_custom_fields_field_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "label"
    t.integer  "group_template_id"
    t.integer  "field_type"
    t.string   "min"
    t.string   "max"
    t.boolean  "required"
    t.text     "instructions"
    t.text     "default_value"
    t.text     "placeholder_text"
    t.string   "prepend"
    t.string   "append"
    t.integer  "rows"
    t.string   "date_format"
    t.string   "time_format"
    t.string   "accepted_file_types"
    t.string   "toolbar"
    t.text     "choices"
    t.boolean  "multiple"
    t.integer  "parent_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "row_order"
    t.index ["group_template_id"], name: "bpf_ft_gt", using: :btree
  end

  create_table "bp_custom_fields_fields", force: :cascade do |t|
    t.integer  "field_template_id"
    t.integer  "group_id"
    t.text     "value"
    t.string   "file"
    t.integer  "parent_id"
    t.boolean  "container"
    t.integer  "row_order"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["field_template_id"], name: "bpf_f_ft", using: :btree
    t.index ["group_id"], name: "bpf_f_g", using: :btree
  end

  create_table "bp_custom_fields_group_templates", force: :cascade do |t|
    t.string   "name"
    t.boolean  "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bp_custom_fields_groups", force: :cascade do |t|
    t.integer  "group_template_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "groupable_type"
    t.integer  "groupable_id"
    t.index ["group_template_id"], name: "index_bp_custom_fields_groups_on_group_template_id", using: :btree
  end

  create_table "carts", force: :cascade do |t|
    t.string   "uid"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "line_items", force: :cascade do |t|
    t.string   "itemized_type"
    t.integer  "itemized_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.integer  "quantity",                                            default: 0
    t.string   "name"
    t.string   "uid"
    t.integer  "price_cents"
    t.string   "price_cents_currency"
    t.integer  "shipping_base_cents"
    t.string   "shipping_base_currency"
    t.integer  "additional_shipping_per_item_cents"
    t.string   "additional_shipping_per_item_currency"
    t.integer  "international_shipping_base_cents"
    t.string   "international_shipping_base_currency"
    t.integer  "additional_international_shipping_per_item_cents"
    t.string   "additional_international_shipping_per_item_currency"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.index ["itemized_type", "itemized_id"], name: "index_line_items_on_itemized_type_and_itemized_id", using: :btree
    t.index ["product_id"], name: "index_line_items_on_product_id", using: :btree
  end

  create_table "option_values", force: :cascade do |t|
    t.string   "value"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_id"], name: "index_option_values_on_option_id", using: :btree
  end

  create_table "option_values_variants", id: false, force: :cascade do |t|
    t.integer "option_value_id"
    t.integer "variant_id"
    t.index ["option_value_id"], name: "index_option_values_variants_on_option_value_id", using: :btree
    t.index ["variant_id"], name: "index_option_values_variants_on_variant_id", using: :btree
  end

  create_table "options", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "options_products", id: false, force: :cascade do |t|
    t.integer "option_id"
    t.integer "product_id"
    t.index ["option_id"], name: "index_options_products_on_option_id", using: :btree
    t.index ["product_id"], name: "index_options_products_on_product_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "uid"
    t.string   "short_uid"
    t.datetime "purchased_at"
    t.string   "status"
    t.string   "payment_method"
    t.datetime "deleted_at"
    t.string   "payment_provider_key"
    t.boolean  "live",                    default: true
    t.string   "payment_email"
    t.string   "contact_email"
    t.string   "slug"
    t.boolean  "shipping_same"
    t.integer  "subtotal_cents"
    t.string   "subtotal_cents_currency"
    t.integer  "shipping_total_cents"
    t.string   "shipping_total_currency"
    t.integer  "grand_total_cents"
    t.string   "grand_total_currency"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "page_templates", force: :cascade do |t|
    t.text     "body"
    t.boolean  "active"
    t.string   "title"
    t.string   "page"
    t.string   "slug"
    t.integer  "row_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "caption"
    t.string   "image"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "row_order"
    t.string   "photoable_type"
    t.integer  "photoable_id"
    t.integer  "tagged_row_order"
    t.index ["photoable_type", "photoable_id"], name: "index_photos_on_photoable_type_and_photoable_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "price_cents"
    t.string   "price_cents_currency"
    t.integer  "quantity"
    t.integer  "weight_in_oz"
    t.integer  "row_order"
    t.boolean  "using_inventory",                                     default: false
    t.integer  "shipping_base_cents"
    t.string   "shipping_base_currency"
    t.integer  "additional_shipping_per_item_cents"
    t.string   "additional_shipping_per_item_currency"
    t.integer  "international_shipping_base_cents"
    t.string   "international_shipping_base_currency"
    t.integer  "additional_international_shipping_per_item_cents"
    t.string   "additional_international_shipping_per_item_currency"
    t.string   "slug"
    t.integer  "state"
    t.datetime "deleted_at"
    t.string   "uid"
    t.boolean  "taken_down"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.boolean  "published",                                           default: false
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.integer  "row_order",                 default: 0
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.integer "row_order"
    t.string  "slug"
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "themes", force: :cascade do |t|
    t.text     "css"
    t.boolean  "active",     default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "css_file"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "variants", force: :cascade do |t|
    t.integer  "price_cents"
    t.string   "price_cents_currency"
    t.string   "sku"
    t.integer  "quantity"
    t.integer  "weight_in_oz"
    t.integer  "row_order"
    t.string   "slug"
    t.boolean  "published"
    t.string   "state"
    t.string   "uid"
    t.datetime "deleted_at"
    t.integer  "product_id"
    t.boolean  "using_inventory",                                     default: false
    t.integer  "shipping_base_cents"
    t.string   "shipping_base_currency"
    t.integer  "additional_shipping_per_item_cents"
    t.string   "additional_shipping_per_item_currency"
    t.integer  "international_shipping_base_cents"
    t.string   "international_shipping_base_currency"
    t.integer  "additional_international_shipping_per_item_cents"
    t.string   "additional_international_shipping_per_item_currency"
    t.datetime "created_at",                                                          null: false
    t.datetime "updated_at",                                                          null: false
    t.index ["product_id"], name: "index_variants_on_product_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  create_table "videos", force: :cascade do |t|
    t.string   "caption"
    t.string   "address"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "row_order"
  end

  add_foreign_key "option_values", "options"
end
