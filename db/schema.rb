# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 46) do

  create_table "app_configs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assistants", :force => true do |t|
    t.integer  "user_id"
    t.float    "benefit"
    t.float    "other"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assistants", ["user_id"], :name => "index_assistants_on_user_id"

  create_table "bank_cards", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bank_id"
    t.string   "card_number"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_cards", ["bank_id"], :name => "index_bank_cards_on_bank_id"
  add_index "bank_cards", ["user_id"], :name => "index_bank_cards_on_user_id"

  create_table "banks", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_salaries", :force => true do |t|
    t.integer  "user_id"
    t.float    "station_sa"
    t.float    "position_sa"
    t.float    "station_be"
    t.float    "foreign_be"
    t.float    "region_be"
    t.float    "hard_be"
    t.float    "stay_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "basic_salaries", ["user_id"], :name => "index_basic_salaries_on_user_id"

  create_table "basic_salary_records", :force => true do |t|
    t.integer  "user_id",     :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "station_sa"
    t.float    "position_sa"
    t.float    "station_be"
    t.float    "foreign_be"
    t.float    "region_be"
    t.float    "add_sa"
    t.float    "hard_be"
    t.float    "stay_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "basic_salary_records", ["user_id"], :name => "index_basic_salary_records_on_user_id"

  create_table "class_benefits", :force => true do |t|
    t.integer  "user_id"
    t.float    "total_be"
    t.string   "term"
    t.integer  "month"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_verified", :default => false
  end

  add_index "class_benefits", ["user_id"], :name => "index_class_benefits_on_user_id"

  create_table "class_month_benefit_records", :force => true do |t|
    t.integer  "user_id"
    t.float    "fee"
    t.integer  "month"
    t.integer  "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "class_month_benefit_records", ["user_id"], :name => "index_class_month_benefit_records_on_user_id"

  create_table "college_be_records", :force => true do |t|
    t.integer  "user_id",    :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "life_be"
    t.float    "diff_be"
    t.float    "livesa_be"
    t.float    "tv_be"
    t.float    "beaulty_be"
    t.float    "other_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "college_be_records", ["user_id"], :name => "index_college_be_records_on_user_id"

  create_table "college_benefits", :force => true do |t|
    t.integer  "user_id"
    t.float    "life_be"
    t.float    "diff_be"
    t.float    "livesa_be"
    t.float    "tv_be"
    t.float    "beaulty_be"
    t.float    "other_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "college_benefits", ["user_id"], :name => "index_college_benefits_on_user_id"

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_cutting_records", :force => true do |t|
    t.integer  "user_id",     :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "room_fee"
    t.float    "med_fee"
    t.float    "elc_fee"
    t.float    "job_fee"
    t.float    "selfedu_fee"
    t.float    "other_fee1"
    t.float    "other_fee2"
    t.float    "other_fee3"
    t.float    "self_tax"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "net_fee"
  end

  add_index "fee_cutting_records", ["user_id"], :name => "index_fee_cutting_records_on_user_id"

  create_table "fee_cuttings", :force => true do |t|
    t.integer  "user_id"
    t.float    "room_fee"
    t.float    "med_fee"
    t.float    "job_fee"
    t.float    "selfedu_fee"
    t.float    "other_fee1"
    t.float    "other_fee2"
    t.float    "other_fee3"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "net_fee"
    t.float    "elc_fee"
  end

  add_index "fee_cuttings", ["user_id"], :name => "index_fee_cuttings_on_user_id"

  create_table "page_modules", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
    t.integer  "index",       :default => 1
  end

  create_table "page_roles", :force => true do |t|
    t.integer  "page_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "page_roles", ["page_id"], :name => "index_page_roles_on_page_id"
  add_index "page_roles", ["role_id"], :name => "index_page_roles_on_role_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.text     "function"
    t.string   "url"
    t.integer  "page_module_id"
    t.boolean  "hidden"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
  end

  add_index "pages", ["page_module_id"], :name => "index_pages_on_page_module_id"

  create_table "performance_benefit_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "term"
    t.float    "fee"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performance_benefit_records", ["user_id"], :name => "index_performance_benefit_records_on_user_id"

  create_table "performance_benefit_stds", :force => true do |t|
    t.integer  "user_id"
    t.float    "std_fee"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "performance_benefit_stds", ["user_id"], :name => "index_performance_benefit_stds_on_user_id"

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "retired_basic_salaries", :force => true do |t|
    t.integer  "user_id"
    t.float    "basic_fee"
    t.float    "stay_be"
    t.float    "foreign_be"
    t.float    "region_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_basic_salaries", ["user_id"], :name => "index_retired_basic_salaries_on_user_id"

  create_table "retired_basic_salary_records", :force => true do |t|
    t.integer  "user_id",    :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "basic_fee"
    t.float    "stay_be"
    t.float    "foreign_be"
    t.float    "region_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_basic_salary_records", ["user_id"], :name => "index_retired_basic_salary_records_on_user_id"

  create_table "retired_college_be_records", :force => true do |t|
    t.integer  "user_id",    :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "diff_be"
    t.float    "tv_be"
    t.float    "beaulty_be"
    t.float    "other_be1"
    t.float    "other_be2"
    t.float    "other_be3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_college_be_records", ["user_id"], :name => "index_retired_college_be_records_on_user_id"

  create_table "retired_college_benefits", :force => true do |t|
    t.integer  "user_id"
    t.float    "diff_be"
    t.float    "tv_be"
    t.float    "beaulty_be"
    t.float    "other_be1"
    t.float    "other_be2"
    t.float    "other_be3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_college_benefits", ["user_id"], :name => "index_retired_college_benefits_on_user_id"

  create_table "retired_fee_cutting_records", :force => true do |t|
    t.integer  "user_id",    :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "elc_fee"
    t.float    "other_fee1"
    t.float    "other_fee2"
    t.float    "other_fee3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_fee_cutting_records", ["user_id"], :name => "index_retired_fee_cutting_records_on_user_id"

  create_table "retired_fee_cuttings", :force => true do |t|
    t.integer  "user_id"
    t.float    "other_fee1"
    t.float    "other_fee2"
    t.float    "other_fee3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retired_fee_cuttings", ["user_id"], :name => "index_retired_fee_cuttings_on_user_id"

  create_table "role_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_users", ["role_id"], :name => "index_role_users_on_role_id"
  add_index "role_users", ["user_id"], :name => "index_role_users_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "science_benefits", :force => true do |t|
    t.integer  "user_id"
    t.float    "science_be"
    t.string   "year"
    t.integer  "month"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_verified", :default => false
  end

  add_index "science_benefits", ["user_id"], :name => "index_science_benefits_on_user_id"

  create_table "station_position_benefit_records", :force => true do |t|
    t.integer  "user_id",     :limit => 255
    t.string   "year"
    t.string   "month"
    t.float    "station_be"
    t.float    "position_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "station_position_benefit_records", ["user_id"], :name => "index_station_position_benefit_records_on_user_id"

  create_table "station_position_benefits", :force => true do |t|
    t.integer  "user_id"
    t.float    "station_be"
    t.float    "position_be"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "station_position_benefits", ["user_id"], :name => "index_station_position_benefits_on_user_id"

  create_table "temp1s", :force => true do |t|
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.string   "f5"
    t.string   "f6"
    t.string   "f7"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp2s", :force => true do |t|
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.string   "f5"
    t.string   "f6"
    t.string   "f8"
    t.string   "f9"
    t.string   "f10"
    t.string   "f11"
    t.string   "f12"
    t.string   "f13"
    t.string   "f14"
    t.string   "f15"
    t.string   "f16"
    t.string   "f17"
    t.string   "f18"
    t.string   "f19"
    t.string   "f20"
    t.string   "f21"
    t.string   "f22"
    t.string   "f23"
    t.string   "f24"
    t.string   "f25"
    t.string   "f26"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp3s", :force => true do |t|
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.string   "f5"
    t.string   "f6"
    t.string   "f7"
    t.string   "f8"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp4s", :force => true do |t|
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.string   "f5"
    t.string   "f6"
    t.string   "f7"
    t.string   "f8"
    t.string   "f9"
    t.string   "f10"
    t.string   "f11"
    t.string   "f12"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temp5s", :force => true do |t|
    t.string   "f1"
    t.string   "f2"
    t.string   "f3"
    t.string   "f4"
    t.string   "f5"
    t.string   "f6"
    t.string   "f7"
    t.string   "f8"
    t.string   "f9"
    t.string   "f10"
    t.string   "f11"
    t.string   "f12"
    t.string   "f13"
    t.string   "f14"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "undefind_fees", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.float    "fee"
    t.datetime "date"
    t.string   "be_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "undefind_fees", ["user_id"], :name => "index_undefind_fees_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.integer  "td_belongs_id"
    t.string   "gender"
    t.integer  "title_id"
    t.integer  "position_id"
    t.datetime "birthday"
    t.string   "id_card"
    t.string   "login_id"
    t.string   "password"
    t.boolean  "is_nature"
    t.boolean  "is_retired"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "theme"
  end

  add_index "users", ["department_id"], :name => "index_users_on_department_id"
  add_index "users", ["position_id"], :name => "index_users_on_position_id"
  add_index "users", ["td_belongs_id"], :name => "index_users_on_td_belongs_id"
  add_index "users", ["title_id"], :name => "index_users_on_title_id"

  create_table "welfare_benefits", :force => true do |t|
    t.integer  "user_id"
    t.string   "subject"
    t.float    "fee"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "welfare_benefits", ["user_id"], :name => "index_welfare_benefits_on_user_id"

end
