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

ActiveRecord::Schema.define(version: 20150714093912) do

  create_table "achievement_periods", force: :cascade do |t|
    t.integer  "year",       limit: 4,                 null: false
    t.integer  "semester",   limit: 4,                 null: false
    t.boolean  "active",     limit: 1, default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "achievement_reports", force: :cascade do |t|
    t.integer  "achievement_period_id", limit: 4
    t.integer  "user_id",               limit: 4
    t.boolean  "relevant",              limit: 1, default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "achievement_reports", ["achievement_period_id"], name: "index_achievement_reports_on_achievement_period_id", using: :btree
  add_index "achievement_reports", ["user_id"], name: "index_achievement_reports_on_user_id", using: :btree

  create_table "achievements", force: :cascade do |t|
    t.text     "description",           limit: 65535
    t.integer  "user_id",               limit: 4
    t.integer  "activity_id",           limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "achievement_period_id", limit: 4
    t.integer  "value",                 limit: 4
    t.float    "cost",                  limit: 24,    default: 0.0, null: false
    t.integer  "status",                limit: 4,     default: 1
    t.text     "comment",               limit: 65535
  end

  add_index "achievements", ["achievement_period_id"], name: "index_achievements_on_achievement_period_id", using: :btree
  add_index "achievements", ["activity_id"], name: "index_achievements_on_activity_id", using: :btree
  add_index "achievements", ["user_id"], name: "index_achievements_on_user_id", using: :btree

  create_table "acl_position", primary_key: "acl_position_id", force: :cascade do |t|
    t.integer  "acl_position_user",       limit: 4,                   null: false
    t.integer  "acl_position_role",       limit: 4,                   null: false
    t.integer  "acl_position_department", limit: 4,                   null: false
    t.string   "acl_position_title",      limit: 300
    t.datetime "started_at"
    t.datetime "acl_position_dismission"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "appointment_id",          limit: 4
    t.boolean  "acl_position_primary",    limit: 1,   default: false
  end

  create_table "acl_role", primary_key: "acl_role_id", force: :cascade do |t|
    t.text     "acl_role_name",        limit: 65535,                null: false
    t.text     "acl_role_description", limit: 65535,                null: false
    t.integer  "acl_role_parent",      limit: 4
    t.boolean  "active",               limit: 1,     default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",          limit: 65535
  end

  create_table "activities", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.text     "description",             limit: 65535
    t.integer  "activity_group_id",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_type_id",        limit: 4
    t.integer  "activity_credit_type_id", limit: 4
    t.boolean  "active",                  limit: 1,                             default: true
    t.boolean  "unique",                  limit: 1,                             default: true
    t.text     "placeholder",             limit: 65535
    t.integer  "base",                    limit: 4,                             default: 1
    t.decimal  "credit",                                precision: 5, scale: 1, default: 0.0
    t.string   "base_name",               limit: 255,                           default: "за одно достижение"
    t.integer  "role_id",                 limit: 4
  end

  add_index "activities", ["activity_credit_type_id"], name: "index_activities_on_activity_credit_type_id", using: :btree
  add_index "activities", ["activity_group_id"], name: "index_activities_on_activity_group_id", using: :btree
  add_index "activities", ["activity_type_id"], name: "index_activities_on_activity_type_id", using: :btree

  create_table "activity_credit_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "allow_education_documents", force: :cascade do |t|
    t.boolean "original",            limit: 1,   default: true
    t.string  "number",              limit: 255
    t.date    "date"
    t.string  "organization",        limit: 255
    t.integer "entrance_benefit_id", limit: 4
  end

  create_table "appointments", force: :cascade do |t|
    t.text     "title",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_student", primary_key: "archive_student_id", force: :cascade do |t|
    t.integer "archive_order",                         limit: 4,                        null: false
    t.integer "student_id",                            limit: 4,                        null: false
    t.integer "student_status",                        limit: 4,                        null: false
    t.integer "student_oldid",                         limit: 4
    t.integer "student_oldperson",                     limit: 4
    t.boolean "student_homeless",                      limit: 1,        default: false, null: false
    t.boolean "student_gender",                        limit: 1,        default: false, null: false
    t.integer "student_fname",                         limit: 4,                        null: false
    t.integer "student_iname",                         limit: 4,                        null: false
    t.integer "student_oname",                         limit: 4,                        null: false
    t.boolean "student_foreign",                       limit: 1,        default: false, null: false
    t.date    "student_birthday"
    t.string  "student_birthplace",                    limit: 200
    t.integer "student_citizenship",                   limit: 4
    t.string  "student_pseries",                       limit: 4
    t.string  "student_pnumber",                       limit: 20
    t.date    "student_pdate"
    t.text    "student_pdepartment",                   limit: 16777215
    t.string  "student_pcode",                         limit: 20
    t.string  "student_pforeign",                      limit: 200
    t.integer "student_married",                       limit: 4
    t.integer "student_army",                          limit: 4
    t.string  "student_army_voenkom",                  limit: 300
    t.string  "student_army_card",                     limit: 300
    t.integer "student_benefits",                      limit: 4
    t.string  "student_registration_region",           limit: 200
    t.string  "student_registration_zip",              limit: 10
    t.text    "student_registration_address",          limit: 16777215
    t.string  "student_residence_region",              limit: 200
    t.string  "student_residence_zip",                 limit: 10
    t.text    "student_residence_address",             limit: 16777215
    t.string  "student_phone_home",                    limit: 45
    t.string  "student_phone_mobile",                  limit: 45
    t.string  "student_email",                         limit: 300
    t.integer "student_room",                          limit: 4
    t.integer "student_hostel_status",                 limit: 4,        default: 1,     null: false
    t.date    "student_hostel_date"
    t.string  "student_hostel_registration_number",    limit: 200
    t.date    "student_hostel_registration_startdate"
    t.date    "student_hostel_registration_date"
    t.string  "student_hostel_contract_number",        limit: 200
    t.date    "student_hostel_contract_startdate"
    t.date    "student_hostel_contract_date"
    t.date    "student_hostel_payment_date"
    t.string  "student_mother_name",                   limit: 300
    t.string  "student_mother_phone",                  limit: 300
    t.string  "student_father_name",                   limit: 300
    t.string  "student_father_phone",                  limit: 300
    t.string  "student_nation",                        limit: 200
    t.string  "student_ticket",                        limit: 200
    t.string  "student_profkom",                       limit: 200
    t.integer "student_region",                        limit: 4,        default: 1,     null: false
    t.integer "student_hostel_temp",                   limit: 4
    t.text    "student_commentary",                    limit: 16777215
    t.integer "student_balance_temp",                  limit: 4
    t.string  "last_name_hint",                        limit: 255
    t.string  "first_name_hint",                       limit: 255
    t.string  "patronym_hint",                         limit: 255
    t.string  "region",                                limit: 200
    t.string  "okrug",                                 limit: 200
    t.string  "city",                                  limit: 200
    t.string  "settlement",                            limit: 200
    t.string  "street",                                limit: 200
    t.string  "house",                                 limit: 10
    t.string  "building",                              limit: 100
    t.integer "flat",                                  limit: 4
    t.string  "birth_region",                          limit: 200
    t.string  "birth_okrug",                           limit: 200
    t.string  "birth_city",                            limit: 200
    t.string  "birth_settlement",                      limit: 200
    t.text    "employer",                              limit: 65535
    t.string  "registration_country_name",             limit: 255
    t.integer "registration_country_code",             limit: 4
    t.string  "registration_region_name",              limit: 255
    t.integer "registration_region_code",              limit: 4
    t.string  "registration_district_name",            limit: 255
    t.integer "registration_district_code",            limit: 4
    t.string  "registration_city_name",                limit: 255
    t.integer "registration_city_code",                limit: 4
    t.string  "registration_city_area_name",           limit: 255
    t.integer "registration_city_area_code",           limit: 4
    t.string  "registration_place_name",               limit: 255
    t.integer "registration_place_code",               limit: 4
    t.string  "registration_street_name",              limit: 255
    t.integer "registration_street_code",              limit: 4
    t.string  "registration_extra_name",               limit: 255
    t.integer "registration_extra_code",               limit: 4
    t.string  "registration_child_extra_name",         limit: 255
    t.integer "registration_child_extra_code",         limit: 4
    t.string  "registration_house",                    limit: 255
    t.string  "registration_building",                 limit: 255
    t.string  "registration_corp",                     limit: 255
    t.string  "registration_flat",                     limit: 255
    t.string  "residence_country_name",                limit: 255
    t.integer "residence_country_code",                limit: 4
    t.string  "residence_region_name",                 limit: 255
    t.integer "residence_region_code",                 limit: 4
    t.string  "residence_district_name",               limit: 255
    t.integer "residence_district_code",               limit: 4
    t.string  "residence_city_name",                   limit: 255
    t.integer "residence_city_code",                   limit: 4
    t.string  "residence_city_area_name",              limit: 255
    t.integer "residence_city_area_code",              limit: 4
    t.string  "residence_place_name",                  limit: 255
    t.integer "residence_place_code",                  limit: 4
    t.string  "residence_street_name",                 limit: 255
    t.integer "residence_street_code",                 limit: 4
    t.string  "residence_extra_name",                  limit: 255
    t.integer "residence_extra_code",                  limit: 4
    t.string  "residence_child_extra_name",            limit: 255
    t.integer "residence_child_extra_code",            limit: 4
    t.string  "residence_house",                       limit: 255
    t.string  "residence_building",                    limit: 255
    t.string  "residence_corp",                        limit: 255
    t.string  "residence_flat",                        limit: 255
  end

  add_index "archive_student", ["archive_order"], name: "archive_order", using: :btree

  create_table "archive_student_group", primary_key: "archive_student_group_id", force: :cascade do |t|
    t.integer  "archive_student_group_order",       limit: 4,                                           null: false
    t.integer  "student_group_id",                  limit: 4,                                           null: false
    t.integer  "student_group_student",             limit: 4,                                           null: false
    t.integer  "student_group_infin",               limit: 4
    t.integer  "student_group_oldstudent",          limit: 4
    t.integer  "student_group_group",               limit: 4,                                           null: false
    t.integer  "student_group_yearin",              limit: 4
    t.integer  "student_group_oldgroup",            limit: 4
    t.string   "student_group_record",              limit: 11
    t.integer  "student_group_tax",                 limit: 4,                             default: 1,   null: false
    t.text     "student_group_contract_customer",   limit: 65535
    t.integer  "student_group_status",              limit: 4,                             default: 1,   null: false
    t.integer  "student_group_speciality",          limit: 4
    t.integer  "student_group_form",                limit: 4
    t.string   "student_group_abit",                limit: 100
    t.string   "student_group_abit_contract",       limit: 255
    t.date     "student_group_abitdate"
    t.integer  "student_group_abitpoints",          limit: 4
    t.string   "student_group_a_school",            limit: 255
    t.integer  "student_group_a_abit_id",           limit: 4
    t.integer  "student_group_a_human_id",          limit: 4
    t.integer  "student_group_a_naprav",            limit: 4
    t.integer  "student_group_a_region_id",         limit: 4
    t.integer  "student_group_a_state_line",        limit: 4
    t.integer  "student_group_a_profile_mark",      limit: 4
    t.integer  "student_group_a_contract_number",   limit: 4
    t.integer  "student_group_a_accept",            limit: 4
    t.integer  "student_group_a_accept_type",       limit: 4
    t.integer  "student_group_a_stags",             limit: 4
    t.integer  "student_group_a_olymp",             limit: 4
    t.integer  "student_group_a_school_id",         limit: 4
    t.integer  "student_group_a_dr_gos",            limit: 4
    t.integer  "student_group_a_finish_year",       limit: 4
    t.string   "student_group_a_att_num",           limit: 25
    t.date     "student_group_a_att_date"
    t.integer  "student_group_a_flang_id",          limit: 4
    t.integer  "student_group_a_kurs",              limit: 4
    t.string   "student_group_a_kurs_num",          limit: 50
    t.integer  "student_group_a_stago",             limit: 4
    t.integer  "student_group_a_right_id",          limit: 4
    t.integer  "student_group_a_marks",             limit: 4
    t.string   "student_group_a_sert_nums",         limit: 255
    t.integer  "student_group_a_exam_types",        limit: 4
    t.integer  "student_group_a_subjects",          limit: 4
    t.integer  "student_group_p_author",            limit: 4
    t.integer  "student_group_p_controller",        limit: 4
    t.text     "student_group_rejected",            limit: 65535
    t.integer  "student_group_rejected_department", limit: 4
    t.decimal  "student_group_vbalance",                          precision: 9, scale: 2, default: 0.0, null: false
    t.decimal  "student_group_balance",                           precision: 9, scale: 2, default: 0.0, null: false
    t.string   "encrypted_password",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token",              limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     limit: 4
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                limit: 255
    t.string   "last_sign_in_ip",                   limit: 255
    t.string   "ciot_login",                        limit: 255
    t.string   "ciot_password",                     limit: 255
    t.integer  "entrant_id",                        limit: 4
  end

  add_index "archive_student_group", ["archive_student_group_order"], name: "archive_student_group_order", using: :btree

  create_table "blanks", force: :cascade do |t|
    t.integer  "type",       limit: 4
    t.integer  "number",     limit: 4
    t.text     "details",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkpoint", primary_key: "checkpoint_id", force: :cascade do |t|
    t.integer  "checkpoint_subject", limit: 4,                 null: false
    t.integer  "checkpoint_type",    limit: 4,    default: 1,  null: false
    t.string   "checkpoint_name",    limit: 200,  default: ""
    t.string   "checkpoint_details", limit: 1000
    t.date     "checkpoint_date",                              null: false
    t.integer  "checkpoint_min",     limit: 4,    default: 0,  null: false
    t.integer  "checkpoint_max",     limit: 4,    default: 0,  null: false
    t.integer  "checkpoint_closed",  limit: 4,    default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkpoint", ["checkpoint_subject"], name: "checkpoint_subject", using: :btree

  create_table "checkpoint_bck", primary_key: "checkpoint_id", force: :cascade do |t|
    t.integer "checkpoint_subject", limit: 4,                                          null: false
    t.integer "checkpoint_type",    limit: 4,                             default: 1,  null: false
    t.string  "checkpoint_name",    limit: 200,                           default: ""
    t.string  "checkpoint_details", limit: 1000
    t.date    "checkpoint_date",                                                       null: false
    t.decimal "checkpoint_min",                  precision: 11, scale: 6
    t.decimal "checkpoint_max",                  precision: 11, scale: 6
    t.integer "checkpoint_closed",  limit: 4,                             default: 0,  null: false
  end

  add_index "checkpoint_bck", ["checkpoint_subject"], name: "checkpoint_subject", using: :btree

  create_table "checkpoint_mark", primary_key: "checkpoint_mark_id", force: :cascade do |t|
    t.integer  "checkpoint_mark_checkpoint", limit: 4,                 null: false
    t.integer  "checkpoint_mark_student",    limit: 4,                 null: false
    t.integer  "checkpoint_mark_mark",       limit: 4,                 null: false
    t.datetime "checkpoint_mark_submitted",                            null: false
    t.boolean  "checkpoint_mark_retake",     limit: 1, default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkpoint_mark", ["checkpoint_mark_checkpoint"], name: "checkpoint_mark_checkpoint", using: :btree
  add_index "checkpoint_mark", ["checkpoint_mark_student"], name: "checkpoint_mark_student", using: :btree

  create_table "common_benefit_item_olympic_diplom_types", force: :cascade do |t|
    t.integer  "common_benefit_item_id", limit: 4, null: false
    t.integer  "olympic_diplom_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_benefit_item_olympics", id: false, force: :cascade do |t|
    t.integer "common_benefit_item_id", limit: 4
    t.integer "use_olympic_id",         limit: 4
  end

  create_table "common_benefit_items", force: :cascade do |t|
    t.integer  "benefit_kind_id",      limit: 4, null: false
    t.boolean  "is_for_all_olympics",  limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",                 limit: 4
    t.integer  "competitive_group_id", limit: 4, null: false
  end

  create_table "competitive_group_items", force: :cascade do |t|
    t.integer  "competitive_group_id", limit: 4, null: false
    t.integer  "education_type_id",    limit: 4, null: false
    t.integer  "direction_id",         limit: 4, null: false
    t.integer  "number_budget_o",      limit: 4
    t.integer  "number_budget_oz",     limit: 4
    t.integer  "number_budget_z",      limit: 4
    t.integer  "number_paid_o",        limit: 4
    t.integer  "number_paid_oz",       limit: 4
    t.integer  "number_paid_z",        limit: 4
    t.integer  "number_quota_o",       limit: 4
    t.integer  "number_quota_oz",      limit: 4
    t.integer  "number_quota_z",       limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "competitive_group_items", ["competitive_group_id"], name: "index_competitive_group_items_on_competitive_group_id", using: :btree
  add_index "competitive_group_items", ["direction_id"], name: "index_competitive_group_items_on_direction_id", using: :btree

  create_table "competitive_group_target_items", force: :cascade do |t|
    t.integer  "target_organization_id", limit: 4, null: false
    t.integer  "number_target_o",        limit: 4
    t.integer  "number_target_oz",       limit: 4
    t.integer  "number_target_z",        limit: 4
    t.integer  "education_level_id",     limit: 4, null: false
    t.integer  "direction_id",           limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "competitive_groups", force: :cascade do |t|
    t.integer  "campaign_id", limit: 4
    t.integer  "course",      limit: 4,   default: 1, null: false
    t.string   "name",        limit: 255,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curator_group", force: :cascade do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.integer "group_id",   limit: 4
    t.integer "user_id",    limit: 4
  end

  add_index "curator_group", ["group_id"], name: "index_curator_group_on_group_id", using: :btree
  add_index "curator_group", ["user_id"], name: "index_curator_group_on_user_id", using: :btree

  create_table "curator_task", force: :cascade do |t|
    t.string   "name",                 limit: 255,   null: false
    t.text     "description",          limit: 65535
    t.integer  "status",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "curator_task_type_id", limit: 4
    t.text     "report",               limit: 65535
  end

  add_index "curator_task", ["curator_task_type_id"], name: "index_curator_task_on_curator_task_type_id", using: :btree

  create_table "curator_task_type", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "curator_task_user", force: :cascade do |t|
    t.integer  "status",          limit: 4, default: 1
    t.boolean  "accepted",        limit: 1
    t.integer  "curator_task_id", limit: 4
    t.integer  "user_id",         limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "curator_task_user", ["curator_task_id"], name: "index_curator_task_user_on_curator_task_id", using: :btree
  add_index "curator_task_user", ["user_id"], name: "index_curator_task_user_on_user_id", using: :btree

  create_table "custom_documents", force: :cascade do |t|
    t.boolean "original",            limit: 1,     default: true
    t.string  "series",              limit: 255
    t.string  "number",              limit: 255
    t.date    "date"
    t.string  "organization",        limit: 255
    t.text    "additional_info",     limit: 65535
    t.string  "type_name",           limit: 255
    t.integer "entrance_benefit_id", limit: 4
  end

  create_table "department", primary_key: "department_id", force: :cascade do |t|
    t.integer "department_oldid",   limit: 4
    t.string  "department_name",    limit: 200,                      null: false
    t.string  "department_sname",   limit: 200,                      null: false
    t.integer "department_prename", limit: 4
    t.string  "department_alias",   limit: 45
    t.string  "department_role",    limit: 200, default: "students"
    t.boolean "department_active",  limit: 1,   default: true,       null: false
    t.integer "department_parent",  limit: 4
    t.string  "name_rp",            limit: 255
    t.string  "short_name_rp",      limit: 255
    t.string  "phone",              limit: 255
  end

  add_index "department", ["department_prename"], name: "department_prename", using: :btree

  create_table "dictionary", primary_key: "dictionary_id", force: :cascade do |t|
    t.text "dictionary_ip", limit: 16777215, null: false
    t.text "dictionary_rp", limit: 16777215, null: false
    t.text "dictionary_dp", limit: 16777215, null: false
    t.text "dictionary_vp", limit: 16777215, null: false
    t.text "dictionary_tp", limit: 16777215, null: false
    t.text "dictionary_pp", limit: 16777215, null: false
  end

  create_table "diplomMasterGroups", force: :cascade do |t|
    t.string "nname", limit: 250
  end

  create_table "directions", force: :cascade do |t|
    t.string   "code",               limit: 255
    t.string   "new_code",           limit: 255
    t.string   "name",               limit: 255
    t.integer  "qualification_code", limit: 4
    t.string   "ugs_code",           limit: 255
    t.string   "ugs_name",           limit: 255
    t.string   "period",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "letters",            limit: 255
    t.integer  "department_id",      limit: 4
    t.integer  "gzgu",               limit: 4
  end

  create_table "discount", primary_key: "discount_id", force: :cascade do |t|
    t.integer "discount_type",          limit: 4,                             null: false
    t.decimal "discount_modifier",                    precision: 3, scale: 2, null: false
    t.integer "discount_year",          limit: 4,                             null: false
    t.integer "discount_semester",      limit: 4,                             null: false
    t.integer "discount_student_group", limit: 4,                             null: false
    t.integer "discount_order",         limit: 4
    t.text    "discount_commentary",    limit: 65535
  end

  add_index "discount", ["discount_semester"], name: "discount_semester", using: :btree
  add_index "discount", ["discount_student_group"], name: "discount_student_group", using: :btree
  add_index "discount", ["discount_type"], name: "discount_type", using: :btree
  add_index "discount", ["discount_year"], name: "discount_year", using: :btree

  create_table "discount_type", primary_key: "discount_type_id", force: :cascade do |t|
    t.text    "discount_type_name",       limit: 65535,                                         null: false
    t.boolean "discount_type_constant",   limit: 1,                             default: false, null: false
    t.boolean "discount_type_invert",     limit: 1,                                             null: false
    t.integer "discount_type_imposition", limit: 1,                             default: 1,     null: false
    t.decimal "discount_type_basic",                    precision: 3, scale: 2
    t.string  "discount_type_commentary", limit: 200
  end

  create_table "dmDoc", id: false, force: :cascade do |t|
    t.integer  "Код",                limit: 4
    t.integer  "КодСтудента",        limit: 4
    t.integer  "КодГруппы",          limit: 4
    t.integer  "ТипДокумента",       limit: 1
    t.string   "ДокОбр",             limit: 255
    t.integer  "ГодДокОбр",          limit: 2
    t.string   "Поступил",           limit: 255
    t.string   "Окончил",            limit: 255
    t.integer  "КодСпециальности",   limit: 2
    t.text     "ТемаДиплома",        limit: 16777215
    t.string   "НомерДиплома",       limit: 50
    t.datetime "ДатаРешения"
    t.binary   "ПДатаРешения",       limit: 1
    t.datetime "ДатаВыдачи"
    t.binary   "ПДатаВыдачи",        limit: 1
    t.string   "РегНомер",           limit: 50
    t.binary   "ПРегНомер",          limit: 1
    t.string   "Специальность",      limit: 255
    t.string   "Квалификация",       limit: 255
    t.string   "Срок",               limit: 50
    t.string   "Специализация",      limit: 255
    t.datetime "Дата_Рождения"
    t.string   "ФИО",                limit: 255
    t.string   "ФИО_Дат",            limit: 255
    t.string   "Место_Рождения",     limit: 255
    t.binary   "Пол",                limit: 1
    t.text     "Примечание",         limit: 16777215
    t.string   "ОценкаДиплом",       limit: 20
    t.string   "НедельДиплом",       limit: 20
    t.float    "ZEДиплом",           limit: 24
    t.binary   "СОтличием",          limit: 1
    t.string   "Непроверено",        limit: 50
    t.integer  "АудЧасов",           limit: 2
    t.string   "SДокОбр",            limit: 50
    t.string   "NДокОбр",            limit: 50
    t.string   "Уровень",            limit: 50
    t.string   "СпецЗвание",         limit: 255
    t.string   "Протокол",           limit: 255
    t.string   "ID",                 limit: 255
    t.string   "ProfessionalStatus", limit: 255
  end

  create_table "dmSpecialities", id: false, force: :cascade do |t|
    t.integer "Код",           limit: 4
    t.string  "Срок_Обучения", limit: 50
    t.string  "Специальность", limit: 255
    t.string  "Специализация", limit: 255
    t.string  "Квалификация",  limit: 50
  end

  create_table "dmStudent", id: false, force: :cascade do |t|
    t.integer  "Код",                limit: 4
    t.string   "Фамилия",            limit: 25
    t.string   "Имя",                limit: 15
    t.string   "Отчество",           limit: 20
    t.string   "ФИО_Дат",            limit: 70
    t.integer  "Статус",             limit: 2
    t.integer  "Код_Группы",         limit: 4
    t.string   "Пол",                limit: 10
    t.datetime "Дата_Рождения"
    t.string   "Кем_Выдан",          limit: 200
    t.string   "Номер_Паспорта",     limit: 50
    t.datetime "Дата_Выдачи"
    t.integer  "Год_Поступления",    limit: 2
    t.string   "Документ",           limit: 50
    t.string   "ГодВыдачи",          limit: 4
    t.integer  "КодСтудентаДеканат", limit: 4
  end

  create_table "dmTypeEdDoc", id: false, force: :cascade do |t|
    t.integer "Код",      limit: 1
    t.string  "Название", limit: 100
  end

  create_table "document", primary_key: "document_id", force: :cascade do |t|
    t.integer  "document_type",        limit: 4,                    null: false
    t.text     "document_number",      limit: 16777215,             null: false
    t.integer  "document_signed",      limit: 1
    t.datetime "document_create_date",                              null: false
    t.date     "document_start_date"
    t.date     "document_expire_date",                              null: false
    t.integer  "document_juridical",   limit: 1,        default: 0, null: false
    t.string   "document_department",  limit: 400
    t.string   "document_name",        limit: 400
    t.integer  "document_eternal",     limit: 4,        default: 0
  end

  create_table "document_meta", primary_key: "document_meta_id", force: :cascade do |t|
    t.integer "document_meta_document", limit: 4,        null: false
    t.string  "document_meta_pattern",  limit: 200,      null: false
    t.text    "document_meta_text",     limit: 16777215, null: false
  end

  add_index "document_meta", ["document_meta_document"], name: "document_meta_document", using: :btree

  create_table "document_student", primary_key: "document_student_id", force: :cascade do |t|
    t.integer "document_student_document",             limit: 4,                        null: false
    t.integer "student_id",                            limit: 4,                        null: false
    t.integer "student_status",                        limit: 4,                        null: false
    t.integer "student_oldid",                         limit: 4
    t.integer "student_oldperson",                     limit: 4
    t.boolean "student_homeless",                      limit: 1,        default: false, null: false
    t.boolean "student_gender",                        limit: 1,        default: false, null: false
    t.integer "student_fname",                         limit: 4,                        null: false
    t.integer "student_iname",                         limit: 4,                        null: false
    t.integer "student_oname",                         limit: 4,                        null: false
    t.boolean "student_foreign",                       limit: 1,        default: false, null: false
    t.date    "student_birthday"
    t.string  "student_birthplace",                    limit: 200
    t.integer "student_citizenship",                   limit: 4
    t.string  "student_pseries",                       limit: 4
    t.string  "student_pnumber",                       limit: 20
    t.date    "student_pdate"
    t.text    "student_pdepartment",                   limit: 16777215
    t.string  "student_pcode",                         limit: 20
    t.string  "student_pforeign",                      limit: 200
    t.integer "student_married",                       limit: 4
    t.string  "student_army_voenkom",                  limit: 300
    t.string  "student_army_card",                     limit: 300
    t.integer "student_army",                          limit: 4
    t.integer "student_benefits",                      limit: 4
    t.string  "student_registration_region",           limit: 200
    t.string  "student_registration_zip",              limit: 10
    t.text    "student_registration_address",          limit: 16777215
    t.string  "student_residence_region",              limit: 200
    t.string  "student_residence_zip",                 limit: 10
    t.text    "student_residence_address",             limit: 16777215
    t.string  "student_phone_home",                    limit: 45
    t.string  "student_phone_mobile",                  limit: 45
    t.string  "student_profkom",                       limit: 200
    t.string  "student_email",                         limit: 300
    t.integer "student_room",                          limit: 4
    t.integer "student_hostel_status",                 limit: 4,        default: 1,     null: false
    t.date    "student_hostel_date"
    t.string  "student_hostel_registration_number",    limit: 200
    t.date    "student_hostel_registration_startdate"
    t.date    "student_hostel_registration_date"
    t.string  "student_hostel_contract_number",        limit: 200
    t.date    "student_hostel_contract_startdate"
    t.date    "student_hostel_contract_date"
    t.date    "student_hostel_payment_date"
    t.string  "student_mother_name",                   limit: 300
    t.string  "student_mother_phone",                  limit: 300
    t.string  "student_father_name",                   limit: 300
    t.string  "student_father_phone",                  limit: 300
    t.string  "student_nation",                        limit: 200
    t.string  "student_ticket",                        limit: 200
    t.integer "student_region",                        limit: 4,        default: 1,     null: false
    t.integer "student_hostel_temp",                   limit: 4
    t.text    "student_commentary",                    limit: 16777215
    t.integer "student_balance_temp",                  limit: 4
    t.string  "last_name_hint",                        limit: 255
    t.string  "first_name_hint",                       limit: 255
    t.string  "patronym_hint",                         limit: 255
    t.string  "region",                                limit: 200
    t.string  "okrug",                                 limit: 200
    t.string  "city",                                  limit: 200
    t.string  "settlement",                            limit: 200
    t.string  "street",                                limit: 200
    t.string  "house",                                 limit: 10
    t.string  "building",                              limit: 100
    t.integer "flat",                                  limit: 4
    t.string  "birth_region",                          limit: 200
    t.string  "birth_okrug",                           limit: 200
    t.string  "birth_city",                            limit: 200
    t.string  "birth_settlement",                      limit: 200
    t.text    "employer",                              limit: 65535
    t.string  "registration_country_name",             limit: 255
    t.integer "registration_country_code",             limit: 4
    t.string  "registration_region_name",              limit: 255
    t.integer "registration_region_code",              limit: 4
    t.string  "registration_district_name",            limit: 255
    t.integer "registration_district_code",            limit: 4
    t.string  "registration_city_name",                limit: 255
    t.integer "registration_city_code",                limit: 4
    t.string  "registration_city_area_name",           limit: 255
    t.integer "registration_city_area_code",           limit: 4
    t.string  "registration_place_name",               limit: 255
    t.integer "registration_place_code",               limit: 4
    t.string  "registration_street_name",              limit: 255
    t.integer "registration_street_code",              limit: 4
    t.string  "registration_extra_name",               limit: 255
    t.integer "registration_extra_code",               limit: 4
    t.string  "registration_child_extra_name",         limit: 255
    t.integer "registration_child_extra_code",         limit: 4
    t.string  "registration_house",                    limit: 255
    t.string  "registration_building",                 limit: 255
    t.string  "registration_corp",                     limit: 255
    t.string  "registration_flat",                     limit: 255
    t.string  "residence_country_name",                limit: 255
    t.integer "residence_country_code",                limit: 4
    t.string  "residence_region_name",                 limit: 255
    t.integer "residence_region_code",                 limit: 4
    t.string  "residence_district_name",               limit: 255
    t.integer "residence_district_code",               limit: 4
    t.string  "residence_city_name",                   limit: 255
    t.integer "residence_city_code",                   limit: 4
    t.string  "residence_city_area_name",              limit: 255
    t.integer "residence_city_area_code",              limit: 4
    t.string  "residence_place_name",                  limit: 255
    t.integer "residence_place_code",                  limit: 4
    t.string  "residence_street_name",                 limit: 255
    t.integer "residence_street_code",                 limit: 4
    t.string  "residence_extra_name",                  limit: 255
    t.integer "residence_extra_code",                  limit: 4
    t.string  "residence_child_extra_name",            limit: 255
    t.integer "residence_child_extra_code",            limit: 4
    t.string  "residence_house",                       limit: 255
    t.string  "residence_building",                    limit: 255
    t.string  "residence_corp",                        limit: 255
    t.string  "residence_flat",                        limit: 255
  end

  add_index "document_student", ["document_student_document"], name: "document_student_document", using: :btree
  add_index "document_student", ["student_id"], name: "student_id", using: :btree

  create_table "document_student_group", primary_key: "document_student_group_id", force: :cascade do |t|
    t.integer  "document_student_group_document",   limit: 4,                                           null: false
    t.integer  "student_group_id",                  limit: 4,                                           null: false
    t.integer  "student_group_student",             limit: 4,                                           null: false
    t.integer  "student_group_infin",               limit: 4
    t.integer  "student_group_oldstudent",          limit: 4
    t.integer  "student_group_group",               limit: 4,                                           null: false
    t.integer  "student_group_yearin",              limit: 4
    t.integer  "student_group_oldgroup",            limit: 4
    t.string   "student_group_record",              limit: 11
    t.integer  "student_group_tax",                 limit: 4,                             default: 1,   null: false
    t.text     "student_group_contract_customer",   limit: 65535
    t.integer  "student_group_status",              limit: 4,                             default: 1,   null: false
    t.integer  "student_group_speciality",          limit: 4
    t.integer  "student_group_form",                limit: 4
    t.string   "student_group_abit",                limit: 100
    t.string   "student_group_abit_contract",       limit: 255
    t.date     "student_group_abitdate"
    t.integer  "student_group_abitpoints",          limit: 4
    t.string   "student_group_a_school",            limit: 255
    t.integer  "student_group_a_abit_id",           limit: 4
    t.integer  "student_group_a_human_id",          limit: 4
    t.integer  "student_group_a_naprav",            limit: 4
    t.integer  "student_group_a_region_id",         limit: 4
    t.integer  "student_group_a_state_line",        limit: 4
    t.integer  "student_group_a_profile_mark",      limit: 4
    t.integer  "student_group_a_contract_number",   limit: 4
    t.integer  "student_group_a_accept",            limit: 4
    t.integer  "student_group_a_accept_type",       limit: 4
    t.integer  "student_group_a_stags",             limit: 4
    t.integer  "student_group_a_olymp",             limit: 4
    t.integer  "student_group_a_school_id",         limit: 4
    t.integer  "student_group_a_dr_gos",            limit: 4
    t.integer  "student_group_a_finish_year",       limit: 4
    t.string   "student_group_a_att_num",           limit: 25
    t.date     "student_group_a_att_date"
    t.integer  "student_group_a_flang_id",          limit: 4
    t.integer  "student_group_a_kurs",              limit: 4
    t.string   "student_group_a_kurs_num",          limit: 50
    t.integer  "student_group_a_stago",             limit: 4
    t.integer  "student_group_a_right_id",          limit: 4
    t.integer  "student_group_a_marks",             limit: 4
    t.string   "student_group_a_sert_nums",         limit: 255
    t.integer  "student_group_a_exam_types",        limit: 4
    t.integer  "student_group_a_subjects",          limit: 4
    t.integer  "student_group_p_author",            limit: 4
    t.integer  "student_group_p_controller",        limit: 4
    t.text     "student_group_rejected",            limit: 65535
    t.integer  "student_group_rejected_department", limit: 4
    t.decimal  "student_group_vbalance",                          precision: 9, scale: 2, default: 0.0, null: false
    t.decimal  "student_group_balance",                           precision: 9, scale: 2, default: 0.0, null: false
    t.string   "encrypted_password",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token",              limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     limit: 4
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                limit: 255
    t.string   "last_sign_in_ip",                   limit: 255
    t.string   "ciot_login",                        limit: 255
    t.string   "ciot_password",                     limit: 255
    t.integer  "entrant_id",                        limit: 4
  end

  add_index "document_student_group", ["document_student_group_document"], name: "document_student_group_document", using: :btree
  add_index "document_student_group", ["student_group_id"], name: "student_group_id", using: :btree
  add_index "document_student_group", ["student_group_student"], name: "student_group_student", using: :btree

  create_table "education_forms", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_forms_entrance_campaigns", id: false, force: :cascade do |t|
    t.integer "campaign_id",       limit: 4
    t.integer "education_form_id", limit: 4
  end

  create_table "education_levels", force: :cascade do |t|
    t.integer  "course",            limit: 4, default: 1, null: false
    t.integer  "education_type_id", limit: 4, default: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_prices", force: :cascade do |t|
    t.integer  "direction_id",      limit: 4
    t.integer  "education_form_id", limit: 4
    t.integer  "entrance_year",     limit: 4
    t.integer  "course",            limit: 4
    t.decimal  "price",                       precision: 9, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_sources", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "education_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee", primary_key: "employee_id", force: :cascade do |t|
    t.integer "employee_dictionary_iname", limit: 4, null: false
    t.integer "employee_dictionary_oname", limit: 4, null: false
    t.integer "employee_dictionary_fname", limit: 4, null: false
  end

  create_table "employee_position", primary_key: "employee_position_id", force: :cascade do |t|
    t.integer  "employee_position_employee",  limit: 4,                null: false
    t.integer  "employee_position_position",  limit: 4,                null: false
    t.boolean  "employee_position_temporary", limit: 1,                null: false
    t.datetime "employee_position_since",                              null: false
    t.boolean  "employee_position_active",    limit: 1, default: true, null: false
  end

  add_index "employee_position", ["employee_position_employee"], name: "employee_position_employee", using: :btree
  add_index "employee_position", ["employee_position_position"], name: "employee_position_position", using: :btree

  create_table "entrance_achievement_types", force: :cascade do |t|
    t.integer "campaign_id",                limit: 4
    t.integer "institution_achievement_id", limit: 4
    t.integer "max_ball",                   limit: 4
    t.string  "name",                       limit: 255
  end

  create_table "entrance_achievements", force: :cascade do |t|
    t.integer "entrant_id",                   limit: 4
    t.integer "entrance_achievement_type_id", limit: 4
    t.string  "document",                     limit: 255
    t.date    "date"
    t.integer "score",                        limit: 4
  end

  create_table "entrance_applications", force: :cascade do |t|
    t.string   "number",                           limit: 255
    t.integer  "entrant_id",                       limit: 4
    t.date     "registration_date"
    t.date     "last_deny_date"
    t.boolean  "need_hostel",                      limit: 1
    t.integer  "status_id",                        limit: 4,     default: 4,     null: false
    t.text     "comment",                          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id",                      limit: 4,                     null: false
    t.integer  "competitive_group_item_id",        limit: 4
    t.boolean  "original",                         limit: 1,     default: false
    t.boolean  "packed",                           limit: 1
    t.integer  "package_id",                       limit: 4
    t.integer  "competitive_group_target_item_id", limit: 4
    t.integer  "order_id",                         limit: 4
    t.boolean  "agree",                            limit: 1
    t.boolean  "prikladnoy",                       limit: 1,     default: false
    t.boolean  "is_payed",                         limit: 1
    t.integer  "education_form_id",                limit: 4
  end

  add_index "entrance_applications", ["campaign_id"], name: "index_entrance_applications_on_campaign_id", using: :btree
  add_index "entrance_applications", ["competitive_group_item_id"], name: "index_entrance_applications_on_competitive_group_item_id", using: :btree
  add_index "entrance_applications", ["competitive_group_target_item_id"], name: "index_entrance_applications_on_competitive_group_target_item_id", using: :btree
  add_index "entrance_applications", ["entrant_id"], name: "index_entrance_applications_on_entrant_id", using: :btree
  add_index "entrance_applications", ["package_id"], name: "index_entrance_applications_on_package_id", using: :btree
  add_index "entrance_applications", ["status_id"], name: "index_entrance_applications_on_status_id", using: :btree

  create_table "entrance_benefit_kinds", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name", limit: 255
  end

  create_table "entrance_benefits", force: :cascade do |t|
    t.integer  "application_id",   limit: 4
    t.integer  "benefit_kind_id",  limit: 4
    t.integer  "document_type_id", limit: 4
    t.string   "temp_text",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entrance_benefits", ["application_id"], name: "index_entrance_benefits_on_application_id", using: :btree
  add_index "entrance_benefits", ["benefit_kind_id"], name: "index_entrance_benefits_on_benefit_kind_id", using: :btree
  add_index "entrance_benefits", ["document_type_id"], name: "index_entrance_benefits_on_document_type_id", using: :btree

  create_table "entrance_campaigns", force: :cascade do |t|
    t.string   "name",       limit: 255,             null: false
    t.integer  "start_year", limit: 4,               null: false
    t.integer  "end_year",   limit: 4,               null: false
    t.integer  "status",     limit: 4,   default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_classrooms", force: :cascade do |t|
    t.string  "number", limit: 255
    t.integer "sits",   limit: 4
  end

  create_table "entrance_contracts", force: :cascade do |t|
    t.string   "number",                limit: 255
    t.integer  "application_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sides",                 limit: 4,   default: 2, null: false
    t.string   "delegate_last_name",    limit: 255
    t.string   "delegate_first_name",   limit: 255
    t.string   "delegate_patronym",     limit: 255
    t.string   "delegate_address",      limit: 255
    t.string   "delegate_phone",        limit: 255
    t.string   "delegate_pseries",      limit: 255
    t.string   "delegate_pnumber",      limit: 255
    t.string   "delegate_pdepartment",  limit: 255
    t.date     "delegate_pdate"
    t.string   "delegate_mobile",       limit: 255
    t.string   "delegate_fax",          limit: 255
    t.string   "delegate_inn",          limit: 255
    t.string   "delegate_kpp",          limit: 255
    t.string   "delegate_ls",           limit: 255
    t.string   "delegate_bik",          limit: 255
    t.string   "delegate_position",     limit: 255
    t.string   "delegate_organization", limit: 255
  end

  add_index "entrance_contracts", ["application_id"], name: "index_entrance_contracts_on_application_id", using: :btree

  create_table "entrance_dates", force: :cascade do |t|
    t.integer  "campaign_id",         limit: 4,             null: false
    t.integer  "course",              limit: 4, default: 1, null: false
    t.date     "start_date",                                null: false
    t.date     "end_date",                                  null: false
    t.date     "order_date",                                null: false
    t.integer  "education_form_id",   limit: 4,             null: false
    t.integer  "education_type_id",   limit: 4,             null: false
    t.integer  "education_source_id", limit: 4,             null: false
    t.integer  "stage",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entrance_dates", ["campaign_id"], name: "index_entrance_dates_on_campaign_id", using: :btree
  add_index "entrance_dates", ["education_form_id"], name: "index_entrance_dates_on_education_form_id", using: :btree
  add_index "entrance_dates", ["education_source_id"], name: "index_entrance_dates_on_education_source_id", using: :btree
  add_index "entrance_dates", ["education_type_id"], name: "index_entrance_dates_on_education_type_id", using: :btree

  create_table "entrance_document_movements", force: :cascade do |t|
    t.boolean  "moved",               limit: 1
    t.boolean  "original",            limit: 1
    t.integer  "from_application_id", limit: 4
    t.integer  "to_application_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "original_changed",    limit: 1, default: false
  end

  add_index "entrance_document_movements", ["from_application_id"], name: "index_entrance_document_movements_on_from_application_id", using: :btree
  add_index "entrance_document_movements", ["to_application_id"], name: "index_entrance_document_movements_on_to_application_id", using: :btree

  create_table "entrance_document_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_edu_documents", force: :cascade do |t|
    t.integer  "document_type_id",        limit: 4,   default: 3,     null: false
    t.string   "series",                  limit: 255
    t.string   "number",                  limit: 255
    t.date     "date"
    t.string   "organization",            limit: 255
    t.integer  "graduation_year",         limit: 4
    t.float    "gpa",                     limit: 24
    t.string   "registration_number",     limit: 255
    t.integer  "qualification_type_id",   limit: 4
    t.integer  "direction_id",            limit: 4
    t.integer  "specialization_id",       limit: 4
    t.integer  "profession_id",           limit: 4
    t.string   "document_type_name_text", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "entrant_id",              limit: 4
    t.boolean  "foreign_institution",     limit: 1,   default: false, null: false
    t.boolean  "our_institution",         limit: 1,   default: false, null: false
    t.string   "qualification",           limit: 255
  end

  add_index "entrance_edu_documents", ["direction_id"], name: "index_entrance_edu_documents_on_direction_id", using: :btree
  add_index "entrance_edu_documents", ["document_type_id"], name: "index_entrance_edu_documents_on_document_type_id", using: :btree
  add_index "entrance_edu_documents", ["entrant_id"], name: "index_entrance_edu_documents_on_entrant_id", using: :btree
  add_index "entrance_edu_documents", ["profession_id"], name: "index_entrance_edu_documents_on_profession_id", using: :btree
  add_index "entrance_edu_documents", ["qualification_type_id"], name: "index_entrance_edu_documents_on_qualification_type_id", using: :btree
  add_index "entrance_edu_documents", ["specialization_id"], name: "index_entrance_edu_documents_on_specialization_id", using: :btree

  create_table "entrance_entrants", force: :cascade do |t|
    t.string   "last_name",                     limit: 255
    t.string   "first_name",                    limit: 255
    t.string   "patronym",                      limit: 255
    t.integer  "gender",                        limit: 4,   default: 1,     null: false
    t.string   "snils",                         limit: 255
    t.string   "information",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "campaign_id",                   limit: 4,                   null: false
    t.integer  "citizenship",                   limit: 4,   default: 1,     null: false
    t.date     "birthday",                                                  null: false
    t.string   "birth_place",                   limit: 255,                 null: false
    t.string   "pseries",                       limit: 255
    t.string   "pnumber",                       limit: 255,                 null: false
    t.string   "pdepartment",                   limit: 255,                 null: false
    t.date     "pdate",                                                     null: false
    t.integer  "acountry",                      limit: 4,   default: 0,     null: false
    t.string   "azip",                          limit: 255,                 null: false
    t.string   "aregion",                       limit: 255
    t.string   "aaddress",                      limit: 255,                 null: false
    t.string   "phone",                         limit: 255,                 null: false
    t.integer  "military_service",              limit: 4,   default: 1,     null: false
    t.boolean  "foreign_institution",           limit: 1,   default: false
    t.string   "institution",                   limit: 255
    t.integer  "graduation_year",               limit: 4
    t.string   "certificate_number",            limit: 255
    t.date     "certificate_date"
    t.integer  "foreign_language",              limit: 4
    t.boolean  "need_hostel",                   limit: 1,   default: true
    t.integer  "identity_document_type_id",     limit: 4,   default: 1,     null: false
    t.integer  "nationality_type_id",           limit: 4,   default: 1,     null: false
    t.boolean  "need_hostel_for_exams",         limit: 1,   default: false, null: false
    t.integer  "student_id",                    limit: 4
    t.boolean  "ioo",                           limit: 1,   default: false
    t.string   "registration_country_name",     limit: 255
    t.integer  "registration_country_code",     limit: 4
    t.string   "registration_region_name",      limit: 255
    t.integer  "registration_region_code",      limit: 4
    t.string   "registration_district_name",    limit: 255
    t.integer  "registration_district_code",    limit: 4
    t.string   "registration_city_name",        limit: 255
    t.integer  "registration_city_code",        limit: 4
    t.string   "registration_city_area_name",   limit: 255
    t.integer  "registration_city_area_code",   limit: 4
    t.string   "registration_place_name",       limit: 255
    t.integer  "registration_place_code",       limit: 4
    t.string   "registration_street_name",      limit: 255
    t.integer  "registration_street_code",      limit: 4
    t.string   "registration_extra_name",       limit: 255
    t.integer  "registration_extra_code",       limit: 4
    t.string   "registration_child_extra_name", limit: 255
    t.integer  "registration_child_extra_code", limit: 4
    t.string   "registration_house",            limit: 255
    t.string   "registration_building",         limit: 255
    t.string   "registration_corp",             limit: 255
    t.string   "registration_flat",             limit: 255
    t.string   "residence_country_name",        limit: 255
    t.integer  "residence_country_code",        limit: 4
    t.string   "residence_region_name",         limit: 255
    t.integer  "residence_region_code",         limit: 4
    t.string   "residence_district_name",       limit: 255
    t.integer  "residence_district_code",       limit: 4
    t.string   "residence_city_name",           limit: 255
    t.integer  "residence_city_code",           limit: 4
    t.string   "residence_city_area_name",      limit: 255
    t.integer  "residence_city_area_code",      limit: 4
    t.string   "residence_place_name",          limit: 255
    t.integer  "residence_place_code",          limit: 4
    t.string   "residence_street_name",         limit: 255
    t.integer  "residence_street_code",         limit: 4
    t.string   "residence_extra_name",          limit: 255
    t.integer  "residence_extra_code",          limit: 4
    t.string   "residence_child_extra_name",    limit: 255
    t.integer  "residence_child_extra_code",    limit: 4
    t.string   "residence_house",               limit: 255
    t.string   "residence_building",            limit: 255
    t.string   "residence_corp",                limit: 255
    t.string   "residence_flat",                limit: 255
    t.string   "email",                         limit: 255
    t.boolean  "visible",                       limit: 1,   default: true
  end

  add_index "entrance_entrants", ["campaign_id"], name: "index_entrance_entrants_on_campaign_id", using: :btree
  add_index "entrance_entrants", ["identity_document_type_id"], name: "index_entrance_entrants_on_identity_document_type_id", using: :btree
  add_index "entrance_entrants", ["nationality_type_id"], name: "index_entrance_entrants_on_nationality_type_id", using: :btree
  add_index "entrance_entrants", ["student_id"], name: "index_entrance_entrants_on_student_id", using: :btree

  create_table "entrance_event_entrants", force: :cascade do |t|
    t.integer "entrance_event_id",   limit: 4, null: false
    t.integer "entrance_entrant_id", limit: 4, null: false
    t.integer "classroom_id",        limit: 4
  end

  add_index "entrance_event_entrants", ["entrance_entrant_id"], name: "index_entrance_event_entrants_on_entrance_entrant_id", using: :btree
  add_index "entrance_event_entrants", ["entrance_event_id"], name: "index_entrance_event_entrants_on_entrance_event_id", using: :btree

  create_table "entrance_events", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.text     "description",        limit: 65535
    t.datetime "date"
    t.integer  "campaign_id",        limit: 4,                     null: false
    t.boolean  "with_classroom",     limit: 1
    t.boolean  "with_time",          limit: 1,     default: false
    t.string   "competitive_groups", limit: 255
  end

  add_index "entrance_events", ["campaign_id"], name: "index_entrance_events_on_campaign_id", using: :btree

  create_table "entrance_exam_results", force: :cascade do |t|
    t.integer  "entrant_id", limit: 4,                   null: false
    t.integer  "exam_id",    limit: 4,                   null: false
    t.integer  "score",      limit: 4
    t.integer  "form",       limit: 4,   default: 1,     null: false
    t.string   "document",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "checked",    limit: 1,   default: false
    t.datetime "checked_at"
    t.integer  "old_score",  limit: 4
    t.boolean  "distance",   limit: 1,   default: false
  end

  add_index "entrance_exam_results", ["entrant_id"], name: "index_entrance_exam_results_on_entrant_id", using: :btree
  add_index "entrance_exam_results", ["exam_id"], name: "index_entrance_exam_results_on_exam_id", using: :btree

  create_table "entrance_exams", force: :cascade do |t|
    t.integer  "campaign_id",    limit: 4
    t.boolean  "use",            limit: 1
    t.integer  "use_subject_id", limit: 4
    t.string   "name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form",           limit: 4,   default: 1,     null: false
    t.boolean  "creative",       limit: 1,   default: false
    t.boolean  "visible",        limit: 1,   default: false
  end

  add_index "entrance_exams", ["campaign_id"], name: "index_entrance_exams_on_campaign_id", using: :btree
  add_index "entrance_exams", ["use_subject_id"], name: "index_entrance_exams_on_use_subject_id", using: :btree

  create_table "entrance_logs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "entrant_id", limit: 4
    t.string   "comment",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entrance_logs", ["user_id"], name: "index_entrance_logs_on_user_id", using: :btree

  create_table "entrance_min_scores", force: :cascade do |t|
    t.integer  "score",               limit: 4
    t.integer  "campaign_id",         limit: 4, null: false
    t.integer  "direction_id",        limit: 4, null: false
    t.integer  "education_source_id", limit: 4, null: false
    t.integer  "entrance_exam_id",    limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entrance_min_scores", ["campaign_id"], name: "index_entrance_min_scores_on_campaign_id", using: :btree
  add_index "entrance_min_scores", ["direction_id"], name: "index_entrance_min_scores_on_direction_id", using: :btree
  add_index "entrance_min_scores", ["education_source_id"], name: "index_entrance_min_scores_on_education_source_id", using: :btree
  add_index "entrance_min_scores", ["entrance_exam_id"], name: "index_entrance_min_scores_on_entrance_exam_id", using: :btree

  create_table "entrance_papers", force: :cascade do |t|
    t.string  "name",                limit: 255
    t.string  "publication",         limit: 255
    t.boolean "printed",             limit: 1
    t.integer "lists",               limit: 4
    t.string  "co_authors",          limit: 255
    t.integer "entrance_entrant_id", limit: 4,   null: false
  end

  add_index "entrance_papers", ["entrance_entrant_id"], name: "index_entrance_papers_on_entrance_entrant_id", using: :btree

  create_table "entrance_queries", force: :cascade do |t|
    t.text     "request",    limit: 65535
    t.text     "response",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_test_benefit_item_olympic_diplom_types", force: :cascade do |t|
    t.integer  "entrance_test_benefit_item_id", limit: 4, null: false
    t.integer  "olympic_diplom_type_id",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_test_benefit_item_olympics", id: false, force: :cascade do |t|
    t.integer "entrance_test_benefit_item_id", limit: 4
    t.integer "use_olympic_id",                limit: 4
  end

  create_table "entrance_test_benefit_items", force: :cascade do |t|
    t.integer  "entrance_test_item_id", limit: 4, null: false
    t.integer  "benefit_kind_id",       limit: 4, null: false
    t.boolean  "is_for_all_olympics",   limit: 1
    t.integer  "min_ege_mark",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",                  limit: 4
  end

  create_table "entrance_test_items", force: :cascade do |t|
    t.integer  "competitive_group_id",   limit: 4,   null: false
    t.string   "form",                   limit: 255
    t.integer  "min_score",              limit: 4
    t.integer  "entrance_test_priority", limit: 4
    t.integer  "use_subject_id",         limit: 4
    t.string   "subject_name",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "exam_id",                limit: 4
  end

  add_index "entrance_test_items", ["competitive_group_id"], name: "index_entrance_test_items_on_competitive_group_id", using: :btree
  add_index "entrance_test_items", ["exam_id"], name: "index_entrance_test_items_on_exam_id", using: :btree
  add_index "entrance_test_items", ["use_subject_id"], name: "index_entrance_test_items_on_use_subject_id", using: :btree

  create_table "entrance_test_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entrance_use_check_results", force: :cascade do |t|
    t.text     "exam_name",      limit: 65535
    t.integer  "score",          limit: 4
    t.integer  "exam_result_id", limit: 4
    t.integer  "use_check_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",           limit: 4
  end

  add_index "entrance_use_check_results", ["exam_result_id"], name: "index_entrance_use_check_results_on_exam_result_id", using: :btree
  add_index "entrance_use_check_results", ["use_check_id"], name: "index_entrance_use_check_results_on_use_check_id", using: :btree

  create_table "entrance_use_checks", force: :cascade do |t|
    t.text     "number",     limit: 65535
    t.integer  "year",       limit: 4
    t.date     "date"
    t.integer  "entrant_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entrance_use_checks", ["entrant_id"], name: "index_entrance_use_checks_on_entrant_id", using: :btree

  create_table "event", force: :cascade do |t|
    t.string   "name",              limit: 255,                   null: false
    t.text     "description",       limit: 65535,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_category_id", limit: 4
    t.boolean  "booking",           limit: 1
    t.integer  "status",            limit: 4
    t.boolean  "hasclaims",         limit: 1,     default: false
    t.text     "place",             limit: 65535
  end

  create_table "event_category", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_date", force: :cascade do |t|
    t.date     "date"
    t.time     "time_start"
    t.time     "time_end"
    t.integer  "max_visitors", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id",     limit: 4
  end

  add_index "event_date", ["event_id"], name: "index_event_date_on_event_id", using: :btree

  create_table "event_date_claim", force: :cascade do |t|
    t.string   "fname",      limit: 255
    t.string   "iname",      limit: 255
    t.string   "oname",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id",   limit: 4
    t.integer  "event_id",   limit: 4
    t.integer  "status",     limit: 4
    t.text     "comment",    limit: 65535
  end

  add_index "event_date_claim", ["event_id"], name: "index_event_date_claim_on_event_id", using: :btree
  add_index "event_date_claim", ["group_id"], name: "index_event_date_claim_on_group_id", using: :btree

  create_table "exam", primary_key: "exam_id", force: :cascade do |t|
    t.integer "exam_subject",       limit: 4,                 null: false
    t.integer "exam_type",          limit: 4,                 null: false
    t.integer "exam_weight",        limit: 4, default: 50
    t.date    "exam_date"
    t.integer "exam_parent",        limit: 4
    t.integer "exam_student",       limit: 4
    t.integer "exam_student_group", limit: 4
    t.integer "exam_group",         limit: 4
    t.integer "exam_repeat",        limit: 4
    t.boolean "exam_filled",        limit: 1, default: false
    t.integer "exam_closed",        limit: 4, default: 0,     null: false
  end

  add_index "exam", ["exam_subject"], name: "exam_subject", using: :btree

  create_table "exam_formreader", primary_key: "exam_formreader_id", force: :cascade do |t|
    t.boolean "exam_formreader_parsed", limit: 1,        default: false, null: false
    t.string  "DocNumber",              limit: 16
    t.string  "S1Id",                   limit: 16
    t.float   "S1Result",               limit: 53
    t.string  "S2Id",                   limit: 16
    t.float   "S2Result",               limit: 53
    t.string  "S3Id",                   limit: 16
    t.float   "S3Result",               limit: 53
    t.string  "S4Id",                   limit: 16
    t.float   "S4Result",               limit: 53
    t.string  "S5Id",                   limit: 16
    t.float   "S5Result",               limit: 53
    t.string  "S6Id",                   limit: 16
    t.float   "S6Result",               limit: 53
    t.string  "S7Id",                   limit: 16
    t.float   "S7Result",               limit: 53
    t.string  "S8Id",                   limit: 16
    t.float   "S8Result",               limit: 53
    t.string  "S9Id",                   limit: 16
    t.float   "S9Result",               limit: 53
    t.string  "S10Id",                  limit: 16
    t.float   "S10Result",              limit: 53
    t.string  "S11Id",                  limit: 16
    t.float   "S11Result",              limit: 53
    t.string  "S12Id",                  limit: 16
    t.float   "S12Result",              limit: 53
    t.string  "S13Id",                  limit: 16
    t.float   "S13Result",              limit: 53
    t.string  "S14Id",                  limit: 16
    t.float   "S14Result",              limit: 53
    t.string  "S15Id",                  limit: 16
    t.float   "S15Result",              limit: 53
    t.string  "S16Id",                  limit: 16
    t.float   "S16Result",              limit: 53
    t.string  "S17Id",                  limit: 16
    t.float   "S17Result",              limit: 53
    t.string  "S18Id",                  limit: 16
    t.float   "S18Result",              limit: 53
    t.string  "S19Id",                  limit: 16
    t.float   "S19Result",              limit: 53
    t.string  "S20Id",                  limit: 16
    t.float   "S20Result",              limit: 53
    t.string  "S21Id",                  limit: 16
    t.float   "S21Result",              limit: 53
    t.string  "S22Id",                  limit: 16
    t.float   "S22Result",              limit: 53
    t.string  "S23Id",                  limit: 16
    t.float   "S23Result",              limit: 53
    t.string  "S24Id",                  limit: 16
    t.float   "S24Result",              limit: 53
    t.string  "S25Id",                  limit: 16
    t.float   "S25Result",              limit: 53
    t.string  "S26Id",                  limit: 16
    t.float   "S26Result",              limit: 53
    t.string  "S27Id",                  limit: 16
    t.float   "S27Result",              limit: 53
    t.string  "S28Id",                  limit: 16
    t.float   "S28Result",              limit: 53
    t.string  "S29Id",                  limit: 16
    t.float   "S29Result",              limit: 53
    t.string  "S30Id",                  limit: 16
    t.float   "S30Result",              limit: 53
    t.string  "S31Id",                  limit: 16
    t.float   "S31Result",              limit: 53
    t.string  "S32Id",                  limit: 16
    t.float   "S32Result",              limit: 53
    t.string  "S33Id",                  limit: 16
    t.float   "S33Result",              limit: 53
    t.string  "S34Id",                  limit: 16
    t.float   "S34Result",              limit: 53
    t.string  "S35Id",                  limit: 16
    t.float   "S35Result",              limit: 53
    t.string  "S36Id",                  limit: 16
    t.float   "S36Result",              limit: 53
    t.binary  "ImageData",              limit: 16777215
    t.string  "Created",                limit: 32
    t.string  "Recognized",             limit: 32
    t.string  "Verified",               limit: 32
  end

  add_index "exam_formreader", ["DocNumber"], name: "DocNumber", using: :btree

  create_table "exam_student", primary_key: "exam_student_id", force: :cascade do |t|
    t.integer "exam_student_exam",          limit: 4, null: false
    t.integer "exam_student_student",       limit: 4
    t.integer "exam_student_student_group", limit: 4, null: false
  end

  add_index "exam_student", ["exam_student_exam"], name: "exam_student_exam", using: :btree
  add_index "exam_student", ["exam_student_student_group"], name: "exam_student_student_group", using: :btree

  create_table "finance_discount", primary_key: "finance_discount_id", force: :cascade do |t|
    t.integer "finance_discount_type",          limit: 4,                             null: false
    t.decimal "finance_discount_modifier",                    precision: 3, scale: 2, null: false
    t.integer "finance_discount_year",          limit: 4,                             null: false
    t.integer "finance_discount_semester",      limit: 4,                             null: false
    t.integer "finance_discount_student_group", limit: 4,                             null: false
    t.integer "finance_discount_order",         limit: 4
    t.text    "finance_discount_commentary",    limit: 65535
  end

  add_index "finance_discount", ["finance_discount_semester"], name: "discount_semester", using: :btree
  add_index "finance_discount", ["finance_discount_student_group"], name: "discount_student_group", using: :btree
  add_index "finance_discount", ["finance_discount_type"], name: "discount_type", using: :btree
  add_index "finance_discount", ["finance_discount_year"], name: "discount_year", using: :btree

  create_table "finance_discount_type", primary_key: "finance_discount_type_id", force: :cascade do |t|
    t.text    "finance_discount_type_name",       limit: 65535,                                         null: false
    t.boolean "finance_discount_type_constant",   limit: 1,                             default: false, null: false
    t.boolean "finance_discount_type_invert",     limit: 1,                                             null: false
    t.integer "finance_discount_type_imposition", limit: 1,                             default: 1,     null: false
    t.decimal "finance_discount_type_basic",                    precision: 3, scale: 2
    t.string  "finance_discount_type_commentary", limit: 200
  end

  create_table "finance_payment", primary_key: "finance_payment_id", force: :cascade do |t|
    t.integer  "finance_payment_type",          limit: 4,                                            null: false
    t.integer  "finance_payment_student_group", limit: 4,                                            null: false
    t.datetime "finance_payment_date",                                                               null: false
    t.decimal  "finance_payment_sum",                        precision: 9, scale: 2
    t.boolean  "finance_payment_deleted",       limit: 1,                            default: false, null: false
    t.integer  "finance_payment_user",          limit: 4
    t.string   "finance_payment_comment",       limit: 1000
  end

  add_index "finance_payment", ["finance_payment_student_group"], name: "speciality_payment_student_group", using: :btree
  add_index "finance_payment", ["finance_payment_type"], name: "speciality_payment_type", using: :btree

  create_table "finance_payment_type", primary_key: "finance_payment_type_id", force: :cascade do |t|
    t.integer "finance_payment_type_year",       limit: 4, null: false
    t.integer "finance_payment_type_form",       limit: 4, null: false
    t.integer "finance_payment_type_speciality", limit: 4, null: false
  end

  add_index "finance_payment_type", ["finance_payment_type_form"], name: "speciality_payment_type_form", using: :btree
  add_index "finance_payment_type", ["finance_payment_type_speciality"], name: "speciality_payment_type_speciality", using: :btree
  add_index "finance_payment_type", ["finance_payment_type_year"], name: "speciality_payment_type_year", using: :btree

  create_table "finance_price", primary_key: "finance_price_id", force: :cascade do |t|
    t.integer "finance_price_payment_type", limit: 4,                         null: false
    t.integer "finance_price_year",         limit: 4,                         null: false
    t.integer "finance_price_semester",     limit: 4,                         null: false
    t.decimal "finance_price_price",                  precision: 9, scale: 2, null: false
  end

  add_index "finance_price", ["finance_price_payment_type"], name: "speciality_price_payment_type", using: :btree
  add_index "finance_price", ["finance_price_semester"], name: "speciality_price_semester", using: :btree
  add_index "finance_price", ["finance_price_year"], name: "speciality_price_year", using: :btree

  create_table "finance_recalc", primary_key: "finance_recalc_id", force: :cascade do |t|
    t.integer "finance_recalc_student_group", limit: 4,                         null: false
    t.integer "finance_recalc_year",          limit: 4,                         null: false
    t.integer "finance_recalc_semester",      limit: 4,                         null: false
    t.decimal "finance_recalc_sum",                     precision: 9, scale: 2, null: false
  end

  add_index "finance_recalc", ["finance_recalc_semester"], name: "recalc_semester", using: :btree
  add_index "finance_recalc", ["finance_recalc_student_group"], name: "recalc_student_group", using: :btree
  add_index "finance_recalc", ["finance_recalc_year"], name: "recalc_year", using: :btree

  create_table "flat", primary_key: "flat_id", force: :cascade do |t|
    t.integer "flat_hostel",   limit: 4,              null: false
    t.integer "flat_entrance", limit: 4,              null: false
    t.integer "flat_floor",    limit: 4,              null: false
    t.string  "flat_number",   limit: 45,             null: false
    t.integer "flat_type",     limit: 4,  default: 1, null: false
  end

  add_index "flat", ["flat_hostel"], name: "flatHostel", using: :btree

  create_table "group", primary_key: "group_id", force: :cascade do |t|
    t.integer "group_oldid",         limit: 4
    t.string  "group_name",          limit: 45,                null: false
    t.integer "group_number",        limit: 1,                 null: false
    t.integer "group_course",        limit: 4
    t.integer "group_ncourse",       limit: 4,                 null: false
    t.integer "group_semester",      limit: 1,                 null: false
    t.integer "group_form",          limit: 4,  default: 1,    null: false
    t.integer "group_second_higher", limit: 1,  default: 0,    null: false
    t.integer "group_speciality",    limit: 4,                 null: false
    t.boolean "group_active",        limit: 1,  default: true, null: false
  end

  add_index "group", ["group_speciality"], name: "groupSpeciality", using: :btree

  create_table "hostel", primary_key: "hostel_id", force: :cascade do |t|
    t.string "hostel_name",       limit: 200, null: false
    t.string "hostel_short_name", limit: 200
    t.string "hostel_address",    limit: 200, null: false
  end

  create_table "hostel_offense", force: :cascade do |t|
    t.integer  "kind",        limit: 4
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hostel_payment", primary_key: "hostel_payment_id", force: :cascade do |t|
    t.integer  "hostel_payment_type",     limit: 4,             null: false
    t.integer  "hostel_payment_student",  limit: 4,             null: false
    t.datetime "hostel_payment_date",                           null: false
    t.integer  "hostel_payment_sum",      limit: 4, default: 0, null: false
    t.integer  "hostel_payment_year",     limit: 4,             null: false
    t.integer  "hostel_payment_semester", limit: 4,             null: false
  end

  add_index "hostel_payment", ["hostel_payment_student"], name: "hostel_payment_student", using: :btree
  add_index "hostel_payment", ["hostel_payment_type"], name: "hostel_payment_type", using: :btree

  create_table "hostel_payment_type", primary_key: "hostel_payment_type_id", force: :cascade do |t|
    t.integer "hostel_payment_type_status",  limit: 4,   null: false
    t.integer "hostel_payment_type_tax",     limit: 4,   null: false
    t.string  "hostel_payment_type_name",    limit: 200, null: false
    t.integer "hostel_payment_type_sum",     limit: 4,   null: false
    t.integer "hostel_payment_type_yearsum", limit: 4,   null: false
    t.integer "hostel_payment_type_active",  limit: 1,   null: false
    t.date    "hostel_payment_type_date",                null: false
    t.integer "hostel_payment_type_hostel",  limit: 4
  end

  add_index "hostel_payment_type", ["hostel_payment_type_status"], name: "hostel_payment_type_status", using: :btree
  add_index "hostel_payment_type", ["hostel_payment_type_tax"], name: "hostel_payment_type_tax", using: :btree

  create_table "hostel_report", force: :cascade do |t|
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",    limit: 4
    t.integer  "flat_id",    limit: 4
    t.integer  "status",     limit: 4
  end

  add_index "hostel_report", ["flat_id"], name: "index_hostel_report_on_flat_id", using: :btree
  add_index "hostel_report", ["user_id"], name: "index_hostel_report_on_user_id", using: :btree

  create_table "hostel_report_application", force: :cascade do |t|
    t.string  "name",             limit: 255
    t.integer "papers",           limit: 4
    t.integer "hostel_report_id", limit: 4
  end

  add_index "hostel_report_application", ["hostel_report_id"], name: "index_hostel_report_application_on_hostel_report_id", using: :btree

  create_table "hostel_report_offense", force: :cascade do |t|
    t.integer "hostel_report_id",  limit: 4
    t.integer "hostel_offense_id", limit: 4
    t.text    "details",           limit: 65535
  end

  add_index "hostel_report_offense", ["hostel_offense_id"], name: "index_hostel_report_offense_on_hostel_offense_id", using: :btree
  add_index "hostel_report_offense", ["hostel_report_id"], name: "index_hostel_report_offense_on_hostel_report_id", using: :btree

  create_table "hostel_report_offense_room", force: :cascade do |t|
    t.integer "hostel_report_offense_id", limit: 4
    t.integer "room_id",                  limit: 4
  end

  add_index "hostel_report_offense_room", ["hostel_report_offense_id"], name: "index_hostel_report_offense_room_on_hostel_report_offense_id", using: :btree
  add_index "hostel_report_offense_room", ["room_id"], name: "index_hostel_report_offense_room_on_room_id", using: :btree

  create_table "hostel_report_offense_student", force: :cascade do |t|
    t.integer "hostel_report_offense_id", limit: 4
    t.integer "student_id",               limit: 4
  end

  add_index "hostel_report_offense_student", ["hostel_report_offense_id"], name: "index_hostel_report_offense_student_on_hostel_report_offense_id", using: :btree
  add_index "hostel_report_offense_student", ["student_id"], name: "index_hostel_report_offense_student_on_student_id", using: :btree

  create_table "identity_document_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institution_achievements", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "log", primary_key: "log_id", force: :cascade do |t|
    t.datetime "log_timestamp",                          null: false
    t.integer  "log_priority",  limit: 1,                null: false
    t.integer  "log_user",      limit: 4
    t.string   "log_message",   limit: 500, default: "", null: false
    t.integer  "log_type",      limit: 4
    t.integer  "log_object",    limit: 4
  end

  add_index "log", ["log_user"], name: "log_user", using: :btree

  create_table "mark", primary_key: "mark_id", force: :cascade do |t|
    t.integer "mark_student_group", limit: 4,                 null: false
    t.integer "mark_value",         limit: 4,                 null: false
    t.boolean "mark_rating",        limit: 1, default: false
    t.integer "mark_exam",          limit: 4,                 null: false
    t.date    "mark_date",                                    null: false
    t.boolean "mark_final",         limit: 1, default: true
  end

  add_index "mark", ["mark_exam"], name: "mark_exam", using: :btree

  create_table "mark_final", id: false, force: :cascade do |t|
    t.integer "mark_final_student", limit: 4, default: 0, null: false
    t.integer "mark_final_exam",    limit: 4, default: 0, null: false
    t.integer "mark_final_mark",    limit: 4
  end

  add_index "mark_final", ["mark_final_exam"], name: "mark_final_exam", using: :btree
  add_index "mark_final", ["mark_final_student", "mark_final_exam"], name: "mark_final_unique", unique: true, using: :btree

  create_table "medical_disability_documents", force: :cascade do |t|
    t.boolean "original",            limit: 1,   default: true
    t.string  "series",              limit: 255
    t.string  "number",              limit: 255
    t.date    "date"
    t.string  "organization",        limit: 255
    t.integer "disability_type_id",  limit: 4
    t.integer "kind",                limit: 4
    t.integer "entrance_benefit_id", limit: 4
  end

  create_table "min_ege_marks", force: :cascade do |t|
    t.integer  "common_benefit_item_id", limit: 4, null: false
    t.integer  "use_subject_id",         limit: 4, null: false
    t.integer  "min_mark",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nationality_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "olympic_documents", force: :cascade do |t|
    t.boolean "original",            limit: 1,   default: true
    t.string  "series",              limit: 255
    t.string  "number",              limit: 255
    t.date    "date"
    t.integer "diploma_type_id",     limit: 4
    t.integer "olympic_id",          limit: 4
    t.integer "level_id",            limit: 4
    t.integer "entrance_benefit_id", limit: 4
  end

  create_table "olympic_total_document_subjects", force: :cascade do |t|
    t.integer "subject_id",                limit: 4
    t.integer "olympic_total_document_id", limit: 4
  end

  create_table "olympic_total_documents", force: :cascade do |t|
    t.boolean "original",            limit: 1,   default: true
    t.string  "series",              limit: 255
    t.string  "number",              limit: 255
    t.integer "diploma_type_id",     limit: 4
    t.integer "entrance_benefit_id", limit: 4
  end

  create_table "optional", primary_key: "optional_id", force: :cascade do |t|
    t.integer "optional_form",       limit: 4
    t.integer "optional_speciality", limit: 4
    t.integer "optional_course",     limit: 4
    t.integer "optional_term",       limit: 4
    t.integer "optional_option",     limit: 4
    t.string  "optional_title",      limit: 200
    t.integer "optional_group",      limit: 4
  end

  add_index "optional", ["optional_speciality"], name: "optional_speciality", using: :btree

  create_table "optional_select", primary_key: "optional_select_id", force: :cascade do |t|
    t.integer "optional_select_student",  limit: 4
    t.integer "optional_select_optional", limit: 4
  end

  add_index "optional_select", ["optional_select_optional"], name: "optional_select_optional", using: :btree
  add_index "optional_select", ["optional_select_student"], name: "optional_select_student", using: :btree

  create_table "order", primary_key: "order_id", force: :cascade do |t|
    t.string   "order_number",       limit: 200
    t.integer  "order_revision",     limit: 4,     default: 1, null: false
    t.integer  "order_department",   limit: 4
    t.integer  "order_responsible",  limit: 4
    t.datetime "order_editing",                                null: false
    t.datetime "order_signing"
    t.integer  "order_status",       limit: 4,     default: 1, null: false
    t.text     "order_xsl_content",  limit: 65535
    t.integer  "order_xsl_template", limit: 4
    t.integer  "order_template",     limit: 4,                 null: false
    t.integer  "order_cfaculty",     limit: 4,     default: 1, null: false
    t.integer  "order_sign",         limit: 4
    t.integer  "order_introduce",    limit: 4
    t.string   "order_endorsement",  limit: 300
  end

  add_index "order", ["order_template"], name: "order_template", using: :btree

  create_table "order_meta", primary_key: "order_meta_id", force: :cascade do |t|
    t.integer "order_meta_order",   limit: 4,        null: false
    t.integer "order_meta_type",    limit: 4,        null: false
    t.integer "order_meta_object",  limit: 4,        null: false
    t.string  "order_meta_pattern", limit: 200,      null: false
    t.text    "order_meta_text",    limit: 16777215, null: false
  end

  add_index "order_meta", ["order_meta_order"], name: "order_meta_order", using: :btree

  create_table "order_reason", primary_key: "order_reason_id", force: :cascade do |t|
    t.integer "order_reason_order",  limit: 4, null: false
    t.integer "order_reason_reason", limit: 4, null: false
  end

  add_index "order_reason", ["order_reason_order"], name: "order_reason_order", using: :btree
  add_index "order_reason", ["order_reason_reason"], name: "order_reason_reason", using: :btree

  create_table "order_student", primary_key: "order_student_id", force: :cascade do |t|
    t.integer "order_student_order",            limit: 4, null: false
    t.integer "order_student_student",          limit: 4, null: false
    t.integer "order_student_student_group_id", limit: 4
    t.integer "order_student_cause",            limit: 4, null: false
  end

  add_index "order_student", ["order_student_order"], name: "orderStudentOrder", using: :btree
  add_index "order_student", ["order_student_student"], name: "orderStudentStudent", using: :btree
  add_index "order_student", ["order_student_student_group_id"], name: "order_student_student_group_id", using: :btree

  create_table "order_xsl", primary_key: "order_xsl_id", force: :cascade do |t|
    t.integer  "order_xsl_template", limit: 4,     null: false
    t.text     "order_xsl_content",  limit: 65535, null: false
    t.datetime "order_xsl_time",                   null: false
  end

  add_index "order_xsl", ["order_xsl_template"], name: "order_xsl_template", using: :btree

  create_table "phonebooks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "position", primary_key: "position_id", force: :cascade do |t|
    t.integer "position_dictionary_name", limit: 4, null: false
  end

  create_table "post", primary_key: "post_id", force: :cascade do |t|
    t.string   "post_title", limit: 100,   null: false
    t.text     "post_text",  limit: 65535, null: false
    t.datetime "post_time",                null: false
  end

  create_table "proofs", force: :cascade do |t|
    t.date    "date"
    t.date    "from"
    t.date    "to"
    t.integer "student_group_id", limit: 4
    t.integer "ref_type",         limit: 4
  end

  create_table "purchase_goods", force: :cascade do |t|
    t.string "name",   limit: 255
    t.string "demand", limit: 255
  end

  create_table "purchase_line_items", force: :cascade do |t|
    t.integer "purchase_id",  limit: 4
    t.integer "good_id",      limit: 4
    t.integer "measure",      limit: 4
    t.float   "start_price",  limit: 24
    t.float   "total_price",  limit: 24
    t.float   "count",        limit: 24
    t.integer "period",       limit: 4
    t.date    "p_start_date"
    t.date    "p_end_date"
    t.integer "supplier_id",  limit: 4
    t.integer "published",    limit: 4
    t.integer "contracted",   limit: 4
    t.integer "delivered",    limit: 4
    t.integer "paid",         limit: 4
  end

  create_table "purchase_purchases", force: :cascade do |t|
    t.integer "dep_id",            limit: 4
    t.string  "number",            limit: 255
    t.date    "date_registration"
    t.integer "status",            limit: 4
    t.string  "note",              limit: 255
  end

  create_table "purchase_suppliers", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.integer "inn",     limit: 8
    t.string  "address", limit: 255
    t.string  "phone",   limit: 255
  end

  create_table "ratings", force: :cascade do |t|
    t.integer  "year",       limit: 4
    t.integer  "user_id",    limit: 4
    t.decimal  "rating",               precision: 10, scale: 3
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recalc", primary_key: "recalc_id", force: :cascade do |t|
    t.integer "recalc_student_group", limit: 4,                         null: false
    t.integer "recalc_year",          limit: 4,                         null: false
    t.integer "recalc_semester",      limit: 4,                         null: false
    t.decimal "recalc_sum",                     precision: 9, scale: 2, null: false
  end

  add_index "recalc", ["recalc_semester"], name: "recalc_semester", using: :btree
  add_index "recalc", ["recalc_student_group"], name: "recalc_student_group", using: :btree
  add_index "recalc", ["recalc_year"], name: "recalc_year", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string  "pseries",  limit: 3,   default: "0", null: false
    t.integer "kladr_id", limit: 4,                 null: false
    t.string  "name",     limit: 255,               null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "id_r",                 limit: 4
    t.integer  "number_review",        limit: 4
    t.date     "date_registration"
    t.integer  "status",               limit: 4
    t.integer  "appointments_id",      limit: 4
    t.string   "contract_number",      limit: 255
    t.date     "contract_date"
    t.date     "contract_expires"
    t.integer  "ordt",                 limit: 4
    t.text     "author",               limit: 65535
    t.text     "title",                limit: 65535
    t.integer  "university_id",        limit: 4
    t.integer  "university_auth_id",   limit: 4
    t.float    "cost",                 limit: 24
    t.float    "total_cost",           limit: 24
    t.float    "sheet_number",         limit: 24
    t.integer  "evaluation",           limit: 4
    t.string   "auth_contract_number", limit: 255
    t.date     "date_auth_university"
    t.date     "date_auth_contract"
    t.date     "date_review"
    t.date     "date_accounting"
    t.integer  "paid",                 limit: 4
    t.text     "note",                 limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "room", primary_key: "room_id", force: :cascade do |t|
    t.integer "room_oldid", limit: 4, null: false
    t.integer "room_flat",  limit: 4, null: false
    t.integer "room_seats", limit: 4
  end

  add_index "room", ["room_flat"], name: "roomFlat", using: :btree

  create_table "salary201403", force: :cascade do |t|
    t.integer  "faculty_id",       limit: 4
    t.integer  "department_id",    limit: 4
    t.integer  "user_id",          limit: 4
    t.decimal  "wage_rate",                  precision: 10, scale: 2
    t.boolean  "untouchable",      limit: 1,                          default: false
    t.boolean  "subdepartment",    limit: 1,                          default: false
    t.boolean  "has_report",       limit: 1
    t.decimal  "credits",                    precision: 10, scale: 2
    t.decimal  "previous_premium",           precision: 10
    t.decimal  "new_premium",                precision: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_cycle", primary_key: "schedule_cycle_id", force: :cascade do |t|
    t.integer "schedule_cycle_course",       limit: 4
    t.integer "schedule_cycle_union",        limit: 4
    t.string  "schedule_cycle_subject_type", limit: 30, default: "", null: false
    t.integer "schedule_cycle_group",        limit: 4,               null: false
    t.integer "schedule_cycle_subgroup",     limit: 4,               null: false
    t.integer "schedule_cycle_lecturer",     limit: 4
    t.integer "schedule_cycle_room_type",    limit: 4,               null: false
    t.string  "schedule_cycle_union_type",   limit: 10
  end

  create_table "schedule_dkpv", id: false, force: :cascade do |t|
    t.integer "schedule_dkpv_id",   limit: 4, null: false
    t.integer "schedule_dkpv_nk",   limit: 4, null: false
    t.integer "schedule_dkpv_room", limit: 4
  end

  create_table "schedule_flow", primary_key: "schedule_flow_id", force: :cascade do |t|
    t.string  "schedule_flow_speciality", limit: 30, default: "", null: false
    t.integer "schedule_flow_course",     limit: 4,               null: false
    t.integer "schedule_flow_groups",     limit: 4,               null: false
    t.integer "schedule_flow_students",   limit: 4
    t.date    "schedule_flow_start",                              null: false
    t.date    "schedule_flow_finish",                             null: false
    t.string  "schedule_flow_form",       limit: 2,  default: "", null: false
    t.integer "schedule_flow_days",       limit: 4
  end

  create_table "schedule_kpv", primary_key: "schedule_kpv_id", force: :cascade do |t|
    t.integer "schedule_kpv_union",         limit: 4, null: false
    t.integer "schedule_kpv_subject",       limit: 4
    t.integer "schedule_kpv_room_type",     limit: 4
    t.integer "schedule_kpv_lecturer",      limit: 4
    t.integer "schedule_kpv_subdepartment", limit: 4
  end

  add_index "schedule_kpv", ["schedule_kpv_lecturer"], name: "schedule_kpv_lecturer", using: :btree
  add_index "schedule_kpv", ["schedule_kpv_subject"], name: "schedule_kpv_subject", using: :btree

  create_table "schedule_lecturer", primary_key: "schedule_lecturer_id", force: :cascade do |t|
    t.integer "schedule_lecturer_subdepartment", limit: 4
    t.string  "schedule_lecturer_name",          limit: 50, default: "", null: false
    t.string  "schedule_lecturer_title",         limit: 50
    t.integer "schedule_lecturer_days",          limit: 4
  end

  add_index "schedule_lecturer", ["schedule_lecturer_subdepartment"], name: "schedule_lecturer_subdepartment", using: :btree

  create_table "schedule_part", primary_key: "schedule_part_id", force: :cascade do |t|
    t.integer "schedule_part_cycle",         limit: 4
    t.integer "schedule_part_nk",            limit: 4
    t.integer "schedule_part_kolpar",        limit: 4, null: false
    t.integer "schedule_part_kolzan",        limit: 4, null: false
    t.boolean "schedule_part_chn",           limit: 1, null: false
    t.integer "schedule_part_new_room_type", limit: 4
    t.integer "schedule_part_room_type",     limit: 4
    t.integer "schedule_part_day",           limit: 4, null: false
    t.integer "schedule_part_para",          limit: 4, null: false
    t.integer "schedule_part_start_week",    limit: 4, null: false
    t.integer "schedule_part_end_week",      limit: 4, null: false
    t.integer "schedule_part_priority",      limit: 4
  end

  add_index "schedule_part", ["schedule_part_cycle"], name: "schedule_part_cycle", using: :btree
  add_index "schedule_part", ["schedule_part_room_type"], name: "schedule_part_room_type", using: :btree

  create_table "schedule_plan", id: false, force: :cascade do |t|
    t.integer "schedule_plan_course",        limit: 4, null: false
    t.integer "schedule_plan_flow",          limit: 4, null: false
    t.integer "schedule_plan_subdepartment", limit: 4, null: false
    t.integer "schedule_plan_subject",       limit: 4, null: false
    t.integer "schedule_plan_lectures",      limit: 4
    t.integer "schedule_plan_practical",     limit: 4
    t.integer "schedule_plan_laboratory",    limit: 4
  end

  add_index "schedule_plan", ["schedule_plan_flow"], name: "schedule_plan_flow", using: :btree
  add_index "schedule_plan", ["schedule_plan_subdepartment"], name: "schedule_plan_subdepartment", using: :btree
  add_index "schedule_plan", ["schedule_plan_subject"], name: "schedule_plan_subject", using: :btree

  create_table "schedule_room", primary_key: "schedule_room_id", force: :cascade do |t|
    t.string  "schedule_room_name",     limit: 30, default: "", null: false
    t.string  "schedule_room_building", limit: 6,  default: "", null: false
    t.integer "schedule_room_capacity", limit: 4
    t.integer "schedule_room_zanpar",   limit: 4
  end

  create_table "schedule_subdepartment", primary_key: "schedule_subdepartment_id", force: :cascade do |t|
    t.string "schedule_subdepartment_name", limit: 30, default: "", null: false
  end

  create_table "schedule_subject", primary_key: "schedule_subject_id", force: :cascade do |t|
    t.string "schedule_subject_name", limit: 200, default: "", null: false
  end

  create_table "social_document_types", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "social_documents", force: :cascade do |t|
    t.integer  "student_id",              limit: 4
    t.integer  "social_document_type_id", limit: 4
    t.string   "number",                  limit: 255
    t.string   "department",              limit: 255
    t.date     "start_date"
    t.date     "expire_date"
    t.integer  "status",                  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "form",                    limit: 4
    t.text     "comment",                 limit: 65535
  end

  create_table "speciality", primary_key: "speciality_id", force: :cascade do |t|
    t.integer "speciality_oldid",      limit: 4
    t.string  "speciality_parent",     limit: 45
    t.string  "speciality_code",       limit: 20,                                               null: false
    t.text    "speciality_name",       limit: 16777215,                                         null: false
    t.string  "speciality_shortname",  limit: 20,                                               null: false
    t.string  "speciality_short_name", limit: 10,                                               null: false
    t.boolean "speciality_type",       limit: 1,                                default: false, null: false
    t.integer "speciality_ntype",      limit: 1,                                                null: false
    t.decimal "speciality_olength",                     precision: 2, scale: 1,                 null: false
    t.decimal "speciality_zlength",                     precision: 2, scale: 1,                 null: false
    t.decimal "speciality_ozlength",                    precision: 2, scale: 1,                 null: false
    t.integer "speciality_faculty",    limit: 4,                                                null: false
    t.integer "speciality_ioo",        limit: 4
  end

  add_index "speciality", ["speciality_faculty"], name: "specialityFaculty", using: :btree

  create_table "speciality_payment", primary_key: "speciality_payment_id", force: :cascade do |t|
    t.integer  "speciality_payment_type",          limit: 4,                                            null: false
    t.integer  "speciality_payment_student_group", limit: 4,                                            null: false
    t.datetime "speciality_payment_date",                                                               null: false
    t.decimal  "speciality_payment_sum",                        precision: 9, scale: 2
    t.boolean  "speciality_payment_deleted",       limit: 1,                            default: false, null: false
    t.integer  "speciality_payment_user",          limit: 4
    t.string   "speciality_payment_comment",       limit: 1000
  end

  add_index "speciality_payment", ["speciality_payment_student_group"], name: "speciality_payment_student_group", using: :btree
  add_index "speciality_payment", ["speciality_payment_type"], name: "speciality_payment_type", using: :btree

  create_table "speciality_payment_type", primary_key: "speciality_payment_type_id", force: :cascade do |t|
    t.integer "speciality_payment_type_year",       limit: 4, null: false
    t.integer "speciality_payment_type_form",       limit: 4, null: false
    t.integer "speciality_payment_type_speciality", limit: 4, null: false
  end

  add_index "speciality_payment_type", ["speciality_payment_type_form"], name: "speciality_payment_type_form", using: :btree
  add_index "speciality_payment_type", ["speciality_payment_type_speciality"], name: "speciality_payment_type_speciality", using: :btree
  add_index "speciality_payment_type", ["speciality_payment_type_year"], name: "speciality_payment_type_year", using: :btree

  create_table "speciality_price", primary_key: "speciality_price_id", force: :cascade do |t|
    t.integer "speciality_price_payment_type", limit: 4,                         null: false
    t.integer "speciality_price_year",         limit: 4,                         null: false
    t.integer "speciality_price_semester",     limit: 4,                         null: false
    t.decimal "speciality_price_price",                  precision: 9, scale: 2, null: false
  end

  add_index "speciality_price", ["speciality_price_payment_type"], name: "speciality_price_payment_type", using: :btree
  add_index "speciality_price", ["speciality_price_semester"], name: "speciality_price_semester", using: :btree
  add_index "speciality_price", ["speciality_price_year"], name: "speciality_price_year", using: :btree

  create_table "student", primary_key: "student_id", force: :cascade do |t|
    t.integer "student_status",                        limit: 4,        default: 1,     null: false
    t.integer "student_oldid",                         limit: 4
    t.integer "student_oldperson",                     limit: 4
    t.boolean "student_homeless",                      limit: 1,        default: false, null: false
    t.boolean "student_gender",                        limit: 1,        default: false, null: false
    t.integer "student_fname",                         limit: 4,                        null: false
    t.integer "student_iname",                         limit: 4,                        null: false
    t.integer "student_oname",                         limit: 4,                        null: false
    t.boolean "student_foreign",                       limit: 1,        default: false, null: false
    t.date    "student_birthday"
    t.string  "student_birthplace",                    limit: 200
    t.integer "student_citizenship",                   limit: 4
    t.string  "student_nation",                        limit: 200
    t.string  "student_pseries",                       limit: 8
    t.string  "student_pnumber",                       limit: 20
    t.date    "student_pdate"
    t.text    "student_pdepartment",                   limit: 16777215
    t.string  "student_pcode",                         limit: 20
    t.string  "student_pforeign",                      limit: 200
    t.integer "student_married",                       limit: 4
    t.integer "student_army",                          limit: 4
    t.string  "student_army_voenkom",                  limit: 300
    t.string  "student_army_card",                     limit: 300
    t.integer "student_benefits",                      limit: 4
    t.string  "student_ticket",                        limit: 200
    t.string  "student_profkom",                       limit: 200
    t.integer "student_region",                        limit: 4,        default: 1,     null: false
    t.string  "student_registration_region",           limit: 200
    t.string  "student_registration_zip",              limit: 10
    t.text    "student_registration_address",          limit: 16777215
    t.string  "student_residence_region",              limit: 200
    t.string  "student_residence_zip",                 limit: 10
    t.text    "student_residence_address",             limit: 16777215
    t.string  "student_phone_home",                    limit: 255
    t.string  "student_phone_mobile",                  limit: 255
    t.string  "student_email",                         limit: 300
    t.integer "student_room",                          limit: 4
    t.integer "student_hostel_temp",                   limit: 4
    t.integer "student_hostel_status",                 limit: 4,        default: 1,     null: false
    t.date    "student_hostel_date"
    t.string  "student_hostel_registration_number",    limit: 200
    t.date    "student_hostel_registration_startdate"
    t.date    "student_hostel_registration_date"
    t.string  "student_hostel_contract_number",        limit: 200
    t.date    "student_hostel_contract_startdate"
    t.date    "student_hostel_contract_date"
    t.date    "student_hostel_payment_date"
    t.string  "student_mother_name",                   limit: 300
    t.string  "student_mother_phone",                  limit: 300
    t.string  "student_father_name",                   limit: 300
    t.string  "student_father_phone",                  limit: 300
    t.text    "student_commentary",                    limit: 16777215
    t.integer "student_balance_temp",                  limit: 4
    t.string  "last_name_hint",                        limit: 255
    t.string  "first_name_hint",                       limit: 255
    t.string  "patronym_hint",                         limit: 255
    t.string  "region",                                limit: 200
    t.string  "okrug",                                 limit: 200
    t.string  "city",                                  limit: 200
    t.string  "settlement",                            limit: 200
    t.string  "street",                                limit: 200
    t.string  "house",                                 limit: 10
    t.string  "building",                              limit: 100
    t.integer "flat",                                  limit: 4
    t.string  "birth_region",                          limit: 200
    t.string  "birth_okrug",                           limit: 200
    t.string  "birth_city",                            limit: 200
    t.string  "birth_settlement",                      limit: 200
    t.text    "employer",                              limit: 65535
    t.string  "registration_country_name",             limit: 255
    t.integer "registration_country_code",             limit: 4
    t.string  "registration_region_name",              limit: 255
    t.integer "registration_region_code",              limit: 4
    t.string  "registration_district_name",            limit: 255
    t.integer "registration_district_code",            limit: 4
    t.string  "registration_city_name",                limit: 255
    t.integer "registration_city_code",                limit: 4
    t.string  "registration_city_area_name",           limit: 255
    t.integer "registration_city_area_code",           limit: 4
    t.string  "registration_place_name",               limit: 255
    t.integer "registration_place_code",               limit: 4
    t.string  "registration_street_name",              limit: 255
    t.integer "registration_street_code",              limit: 4
    t.string  "registration_extra_name",               limit: 255
    t.integer "registration_extra_code",               limit: 4
    t.string  "registration_child_extra_name",         limit: 255
    t.integer "registration_child_extra_code",         limit: 4
    t.string  "registration_house",                    limit: 255
    t.string  "registration_building",                 limit: 255
    t.string  "registration_corp",                     limit: 255
    t.string  "registration_flat",                     limit: 255
    t.string  "residence_country_name",                limit: 255
    t.integer "residence_country_code",                limit: 4
    t.string  "residence_region_name",                 limit: 255
    t.integer "residence_region_code",                 limit: 4
    t.string  "residence_district_name",               limit: 255
    t.integer "residence_district_code",               limit: 4
    t.string  "residence_city_name",                   limit: 255
    t.integer "residence_city_code",                   limit: 4
    t.string  "residence_city_area_name",              limit: 255
    t.integer "residence_city_area_code",              limit: 4
    t.string  "residence_place_name",                  limit: 255
    t.integer "residence_place_code",                  limit: 4
    t.string  "residence_street_name",                 limit: 255
    t.integer "residence_street_code",                 limit: 4
    t.string  "residence_extra_name",                  limit: 255
    t.integer "residence_extra_code",                  limit: 4
    t.string  "residence_child_extra_name",            limit: 255
    t.integer "residence_child_extra_code",            limit: 4
    t.string  "residence_house",                       limit: 255
    t.string  "residence_building",                    limit: 255
    t.string  "residence_corp",                        limit: 255
    t.string  "residence_flat",                        limit: 255
  end

  add_index "student", ["student_fname"], name: "studentFname", using: :btree
  add_index "student", ["student_iname"], name: "studentIname", using: :btree
  add_index "student", ["student_oname"], name: "studentOname", using: :btree
  add_index "student", ["student_room"], name: "studentRoom", using: :btree

  create_table "student_group", primary_key: "student_group_id", force: :cascade do |t|
    t.integer  "student_group_student",             limit: 4,                                           null: false
    t.integer  "student_group_infin",               limit: 4
    t.integer  "student_group_oldstudent",          limit: 4
    t.integer  "student_group_group",               limit: 4,                                           null: false
    t.integer  "student_group_yearin",              limit: 4
    t.integer  "student_group_oldgroup",            limit: 4
    t.string   "student_group_record",              limit: 11
    t.integer  "student_group_tax",                 limit: 4,                             default: 1,   null: false
    t.text     "student_group_contract_customer",   limit: 65535
    t.integer  "student_group_status",              limit: 4,                             default: 1,   null: false
    t.integer  "student_group_speciality",          limit: 4
    t.integer  "student_group_form",                limit: 4
    t.string   "student_group_abit",                limit: 100
    t.string   "student_group_abit_contract",       limit: 255
    t.date     "student_group_abitdate"
    t.integer  "student_group_abitpoints",          limit: 4
    t.string   "student_group_a_school",            limit: 255
    t.integer  "student_group_a_abit_id",           limit: 4
    t.integer  "student_group_a_human_id",          limit: 4
    t.integer  "student_group_a_naprav",            limit: 4
    t.integer  "student_group_a_region_id",         limit: 4
    t.integer  "student_group_a_state_line",        limit: 4
    t.integer  "student_group_a_profile_mark",      limit: 4
    t.integer  "student_group_a_contract_number",   limit: 4
    t.integer  "student_group_a_accept",            limit: 4
    t.integer  "student_group_a_accept_type",       limit: 4
    t.integer  "student_group_a_stags",             limit: 4
    t.integer  "student_group_a_olymp",             limit: 4
    t.integer  "student_group_a_school_id",         limit: 4
    t.integer  "student_group_a_dr_gos",            limit: 4
    t.integer  "student_group_a_finish_year",       limit: 4
    t.string   "student_group_a_att_num",           limit: 25
    t.date     "student_group_a_att_date"
    t.integer  "student_group_a_flang_id",          limit: 4
    t.integer  "student_group_a_kurs",              limit: 4
    t.string   "student_group_a_kurs_num",          limit: 50
    t.integer  "student_group_a_stago",             limit: 4
    t.integer  "student_group_a_right_id",          limit: 4
    t.string   "student_group_a_marks",             limit: 30
    t.string   "student_group_a_sert_nums",         limit: 255
    t.string   "student_group_a_exam_types",        limit: 30
    t.string   "student_group_a_subjects",          limit: 30
    t.integer  "student_group_p_author",            limit: 4
    t.integer  "student_group_p_controller",        limit: 4
    t.text     "student_group_rejected",            limit: 65535
    t.integer  "student_group_rejected_department", limit: 4
    t.decimal  "student_group_vbalance",                          precision: 9, scale: 2, default: 0.0, null: false
    t.decimal  "student_group_balance",                           precision: 9, scale: 2, default: 0.0, null: false
    t.string   "encrypted_password",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token",              limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     limit: 4
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                limit: 255
    t.string   "last_sign_in_ip",                   limit: 255
    t.string   "ciot_login",                        limit: 255
    t.string   "ciot_password",                     limit: 255
    t.integer  "entrant_id",                        limit: 4
  end

  add_index "student_group", ["student_group_group"], name: "studentGroupGroup", using: :btree
  add_index "student_group", ["student_group_status"], name: "studentGroupStatus", using: :btree
  add_index "student_group", ["student_group_student"], name: "student_group_student", using: :btree

  create_table "student_quality", id: false, force: :cascade do |t|
    t.integer "student_quality_student", limit: 4, null: false
    t.integer "student_quality_year",    limit: 4, null: false
    t.integer "student_quality_term",    limit: 4, null: false
    t.integer "student_quality_quality", limit: 4
  end

  create_table "study_marks", force: :cascade do |t|
    t.integer  "subject_id", limit: 4
    t.integer  "student_id", limit: 4,             null: false
    t.integer  "mark",       limit: 4,             null: false
    t.integer  "user_id",    limit: 4,             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "retake",     limit: 4, default: 0, null: false
  end

  add_index "study_marks", ["user_id"], name: "index_study_marks_on_user_id", using: :btree

  create_table "study_subjects", force: :cascade do |t|
    t.integer "year",     limit: 4,   null: false
    t.integer "semester", limit: 4,   null: false
    t.integer "group_id", limit: 4,   null: false
    t.string  "title",    limit: 255, null: false
    t.integer "kind",     limit: 4,   null: false
    t.integer "user_id",  limit: 4,   null: false
  end

  add_index "study_subjects", ["group_id"], name: "index_study_subjects_on_group_id", using: :btree
  add_index "study_subjects", ["kind"], name: "kind", using: :btree
  add_index "study_subjects", ["semester"], name: "semester", using: :btree
  add_index "study_subjects", ["title"], name: "title", using: :btree
  add_index "study_subjects", ["user_id"], name: "index_study_subjects_on_user_id", using: :btree
  add_index "study_subjects", ["year"], name: "year", using: :btree

  create_table "subdepartment", primary_key: "subdepartment_id", force: :cascade do |t|
    t.string  "subdepartment_name",       limit: 400, null: false
    t.string  "subdepartment_short_name", limit: 200, null: false
    t.integer "subdepartment_department", limit: 4,   null: false
  end

  add_index "subdepartment", ["subdepartment_department"], name: "subdepartment_department", using: :btree

  create_table "subject", primary_key: "subject_id", force: :cascade do |t|
    t.string  "subject_name",     limit: 600,                 null: false
    t.integer "subject_teacher",  limit: 4
    t.integer "subject_semester", limit: 4,                   null: false
    t.integer "subject_year",     limit: 4,                   null: false
    t.integer "subject_group",    limit: 4,                   null: false
    t.boolean "subject_brs",      limit: 1,   default: false
    t.integer "department_id",    limit: 4
  end

  add_index "subject", ["subject_group"], name: "subject_group", using: :btree

  create_table "subject_teacher", force: :cascade do |t|
    t.integer "subject_id", limit: 4, null: false
    t.integer "teacher_id", limit: 4, null: false
  end

  add_index "subject_teacher", ["teacher_id"], name: "teacher_id", using: :btree

  create_table "support", primary_key: "support_id", force: :cascade do |t|
    t.integer  "support_student",     limit: 4,                     null: false
    t.integer  "support_year",        limit: 4,                     null: false
    t.integer  "support_month",       limit: 4,                     null: false
    t.string   "support_pseries",     limit: 11,    default: "",    null: false
    t.string   "support_pnumber",     limit: 11,    default: "",    null: false
    t.text     "support_pdate",       limit: 65535,                 null: false
    t.text     "support_pdepartment", limit: 65535,                 null: false
    t.text     "support_pbirthday",   limit: 65535,                 null: false
    t.text     "support_paddress",    limit: 65535,                 null: false
    t.text     "support_pphone",      limit: 65535,                 null: false
    t.boolean  "accepted",            limit: 1,     default: false
    t.boolean  "deferred",            limit: 1,     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "support_cause", primary_key: "support_cause_id", force: :cascade do |t|
    t.text "support_cause_title",    limit: 65535, null: false
    t.text "support_cause_pattern",  limit: 65535, null: false
    t.text "support_cause_patternf", limit: 65535
  end

  create_table "support_cause_document_types", force: :cascade do |t|
    t.integer "support_cause_id",        limit: 4
    t.integer "social_document_type_id", limit: 4
  end

  create_table "support_cause_reason", primary_key: "support_cause_reason_id", force: :cascade do |t|
    t.integer "support_cause_reason_cause",  limit: 4, null: false
    t.integer "support_cause_reason_reason", limit: 4, null: false
  end

  create_table "support_options", primary_key: "support_options_id", force: :cascade do |t|
    t.integer "support_options_support", limit: 4, null: false
    t.integer "support_options_cause",   limit: 4, null: false
  end

  create_table "support_reason", primary_key: "support_reason_id", force: :cascade do |t|
    t.text "support_reason_pattern", limit: 65535
  end

  create_table "sushnevo_category", primary_key: "sushnevo_category_id", force: :cascade do |t|
    t.string "sushnevo_category_name",    limit: 100, null: false
    t.string "sushnevo_category_comment", limit: 200
  end

  create_table "sushnevo_flat", primary_key: "sushnevo_flat_id", force: :cascade do |t|
    t.integer "sushnevo_flat_korpus",   limit: 4,  null: false
    t.integer "sushnevo_flat_floor",    limit: 4,  null: false
    t.integer "sushnevo_flat_entrance", limit: 4,  null: false
    t.string  "sushnevo_flat_number",   limit: 20, null: false
    t.integer "sushnevo_flat_type",     limit: 4,  null: false
  end

  create_table "sushnevo_korpus", primary_key: "sushnevo_korpus_id", force: :cascade do |t|
    t.string "sushnevo_korpus_name",  limit: 200, null: false
    t.string "sushnevo_korpus_sname", limit: 200
  end

  create_table "sushnevo_payment", primary_key: "sushnevo_payment_id", force: :cascade do |t|
    t.integer  "sushnevo_payment_type",     limit: 4,                                       null: false
    t.integer  "sushnevo_payment_resident", limit: 4,                                       null: false
    t.datetime "sushnevo_payment_date",                                                     null: false
    t.decimal  "sushnevo_payment_sum",                precision: 9, scale: 2, default: 0.0, null: false
  end

  create_table "sushnevo_payment_type", primary_key: "sushnevo_payment_type_id", force: :cascade do |t|
    t.integer "sushnevo_payment_type_category", limit: 4,                           null: false
    t.string  "sushnevo_payment_type_name",     limit: 200,                         null: false
    t.integer "sushnevo_payment_type_korpus",   limit: 4,                           null: false
    t.integer "sushnevo_payment_type_flat",     limit: 4,                           null: false
    t.decimal "sushnevo_payment_type_sum",                  precision: 9, scale: 2, null: false
  end

  create_table "sushnevo_person", primary_key: "sushnevo_person_id", force: :cascade do |t|
    t.integer "sushnevo_person_category",             limit: 4,        null: false
    t.integer "sushnevo_person_fname",                limit: 4,        null: false
    t.integer "sushnevo_person_iname",                limit: 4
    t.integer "sushnevo_person_oname",                limit: 4
    t.string  "sushnevo_person_pseries",              limit: 10
    t.string  "sushnevo_person_pnumber",              limit: 10
    t.date    "sushnevo_person_pdate"
    t.text    "sushnevo_person_pdepartment",          limit: 16777215
    t.text    "sushnevo_person_registration_address", limit: 16777215
    t.string  "sushnevo_person_hphone",               limit: 45
    t.string  "sushnevo_person_mphone",               limit: 45
    t.string  "sushnevo_person_email",                limit: 200
    t.string  "sushnevo_person_pforeign",             limit: 200
    t.integer "sushnevo_person_parent",               limit: 4
  end

  create_table "sushnevo_resident", primary_key: "sushnevo_resident_id", force: :cascade do |t|
    t.integer  "sushnevo_resident_person_id",      limit: 4,                                     null: false
    t.integer  "sushnevo_resident_room",           limit: 4,                                     null: false
    t.integer  "sushnevo_resident_status",         limit: 4,                         default: 1, null: false
    t.datetime "sushnevo_resident_startdate"
    t.integer  "sushnevo_resident_startpart",      limit: 4,                                     null: false
    t.datetime "sushnevo_resident_enddate"
    t.integer  "sushnevo_resident_endpart",        limit: 4,                                     null: false
    t.integer  "sushnevo_resident_flag_group",     limit: 4,                         default: 0, null: false
    t.integer  "sushnevo_resident_parent_group",   limit: 4
    t.string   "sushnevo_resident_permit_series",  limit: 1
    t.integer  "sushnevo_resident_permit_number",  limit: 4
    t.datetime "sushnevo_resident_statement_time",                                               null: false
    t.decimal  "sushnevo_resident_balance",                  precision: 9, scale: 2,             null: false
  end

  create_table "sushnevo_room", primary_key: "sushnevo_room_id", force: :cascade do |t|
    t.integer "sushnevo_room_flat",  limit: 4, null: false
    t.integer "sushnevo_room_seats", limit: 4
  end

  create_table "target_organizations", force: :cascade do |t|
    t.integer  "competitive_group_id", limit: 4,   null: false
    t.string   "name",                 limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "contract_number",      limit: 255
    t.date     "contract_date"
  end

  create_table "teacher", primary_key: "teacher_id", force: :cascade do |t|
    t.integer "teacher_fname",         limit: 4, null: false
    t.integer "teacher_iname",         limit: 4, null: false
    t.integer "teacher_oname",         limit: 4, null: false
    t.integer "teacher_subdepartment", limit: 4, null: false
    t.integer "teacher_department",    limit: 4
  end

  add_index "teacher", ["teacher_department"], name: "teacher_department", using: :btree
  add_index "teacher", ["teacher_subdepartment"], name: "teacher_subdepartment", using: :btree

  create_table "template", primary_key: "template_id", force: :cascade do |t|
    t.string  "template_name",             limit: 200,                     null: false
    t.string  "template_title",            limit: 500
    t.boolean "template_one",              limit: 1,   default: false,     null: false
    t.boolean "template_several",          limit: 1,   default: false,     null: false
    t.integer "template_hostel",           limit: 4,   default: 0,         null: false
    t.string  "template_role",             limit: 200, default: "faculty", null: false
    t.boolean "template_active",           limit: 1,                       null: false
    t.integer "template_sign",             limit: 4
    t.string  "template_endorsement",      limit: 200
    t.boolean "template_virtual",          limit: 1,   default: false,     null: false
    t.boolean "template_check_form",       limit: 1,   default: true,      null: false
    t.boolean "template_check_tax",        limit: 1,   default: true,      null: false
    t.boolean "template_check_speciality", limit: 1,   default: true,      null: false
    t.boolean "template_check_course",     limit: 1,   default: true,      null: false
  end

  create_table "template_cause", primary_key: "template_cause_id", force: :cascade do |t|
    t.integer "template_cause_template", limit: 4,                    null: false
    t.text    "template_cause_pattern",  limit: 16777215
    t.text    "template_cause_patternf", limit: 16777215
    t.integer "template_cause_active",   limit: 4,        default: 1, null: false
  end

  add_index "template_cause", ["template_cause_template"], name: "template_cause_template", using: :btree

  create_table "template_reason", primary_key: "template_reason_id", force: :cascade do |t|
    t.integer "template_reason_template", limit: 4,        null: false
    t.text    "template_reason_pattern",  limit: 16777215, null: false
  end

  add_index "template_reason", ["template_reason_template"], name: "template_reason_template", using: :btree

  create_table "template_student_group_statuses", force: :cascade do |t|
    t.integer "template_id",         limit: 4
    t.integer "education_status_id", limit: 4
  end

  create_table "universities", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "use_olympics", force: :cascade do |t|
    t.text     "name",       limit: 65535
    t.integer  "number",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year",       limit: 4
  end

  create_table "use_subjects", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user", primary_key: "user_id", force: :cascade do |t|
    t.boolean  "user_active",            limit: 1,   default: true,   null: false
    t.boolean  "user_enabled",           limit: 1,   default: true,   null: false
    t.string   "user_login",             limit: 200,                  null: false
    t.string   "user_password",          limit: 200,                  null: false
    t.date     "user_password_cdate"
    t.string   "user_email",             limit: 200
    t.string   "user_name",              limit: 255
    t.integer  "user_fname",             limit: 4
    t.integer  "user_iname",             limit: 4
    t.integer  "user_oname",             limit: 4
    t.string   "user_role",              limit: 200, default: "user", null: false
    t.integer  "user_department",        limit: 4
    t.integer  "user_faculty",           limit: 4
    t.string   "user_position",          limit: 200
    t.string   "user_position_short",    limit: 200
    t.integer  "user_subdepartment",     limit: 4
    t.string   "user_phone",             limit: 200
    t.string   "encrypted_password",     limit: 255, default: "",     null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name_hint",         limit: 255
    t.string   "first_name_hint",        limit: 255
    t.string   "patronym_hint",          limit: 255
    t.string   "workphone",              limit: 255
  end

  add_index "user", ["reset_password_token"], name: "index_user_on_reset_password_token", unique: true, using: :btree
  add_index "user", ["user_department"], name: "user_department", using: :btree

  create_table "visitor_event_date", force: :cascade do |t|
    t.integer "event_date_id", limit: 4
    t.integer "visitor_id",    limit: 4
    t.string  "visitor_type",  limit: 255
  end

  add_index "visitor_event_date", ["event_date_id"], name: "index_visitor_event_date_on_event_date_id", using: :btree

  add_foreign_key "archive_student", "order", column: "archive_order", primary_key: "order_id", name: "archive_student_ibfk_1", on_update: :cascade
  add_foreign_key "archive_student_group", "order", column: "archive_student_group_order", primary_key: "order_id", name: "archive_student_group_ibfk_1", on_update: :cascade
  add_foreign_key "checkpoint", "subject", column: "checkpoint_subject", primary_key: "subject_id", name: "checkpoint_ibfk_1", on_update: :cascade
  add_foreign_key "checkpoint_mark", "checkpoint", column: "checkpoint_mark_checkpoint", primary_key: "checkpoint_id", name: "checkpoint_mark_ibfk_2", on_update: :cascade
  add_foreign_key "checkpoint_mark", "student_group", column: "checkpoint_mark_student", primary_key: "student_group_id", name: "checkpoint_mark_ibfk_3"
  add_foreign_key "department", "dictionary", column: "department_prename", primary_key: "dictionary_id", name: "department_ibfk_1", on_update: :cascade
  add_foreign_key "discount", "discount_type", column: "discount_type", primary_key: "discount_type_id", name: "discount_ibfk_1", on_update: :cascade
  add_foreign_key "document_meta", "document", column: "document_meta_document", primary_key: "document_id", name: "document_meta_ibfk_1", on_update: :cascade
  add_foreign_key "document_student", "document", column: "document_student_document", primary_key: "document_id", name: "document_student_ibfk_1", on_update: :cascade
  add_foreign_key "document_student_group", "document", column: "document_student_group_document", primary_key: "document_id", name: "document_student_group_ibfk_1", on_update: :cascade
  add_foreign_key "employee_position", "employee", column: "employee_position_employee", primary_key: "employee_id", name: "employee_position_ibfk_1", on_update: :cascade
  add_foreign_key "employee_position", "position", column: "employee_position_position", primary_key: "position_id", name: "employee_position_ibfk_2", on_update: :cascade
  add_foreign_key "exam", "subject", column: "exam_subject", primary_key: "subject_id", name: "exam_ibfk_1", on_update: :cascade
  add_foreign_key "exam_student", "exam", column: "exam_student_exam", primary_key: "exam_id", name: "exam_student_ibfk_1", on_update: :cascade
  add_foreign_key "exam_student", "student_group", column: "exam_student_student_group", primary_key: "student_group_id", name: "exam_student_ibfk_2"
  add_foreign_key "flat", "hostel", column: "flat_hostel", primary_key: "hostel_id", name: "flat_ibfk_1", on_update: :cascade
  add_foreign_key "group", "speciality", column: "group_speciality", primary_key: "speciality_id", name: "group_ibfk_1", on_update: :cascade
  add_foreign_key "hostel_payment", "hostel_payment_type", column: "hostel_payment_type", primary_key: "hostel_payment_type_id", name: "hostel_payment_ibfk_1", on_update: :cascade
  add_foreign_key "hostel_payment", "student", column: "hostel_payment_student", primary_key: "student_id", name: "hostel_payment_ibfk_2", on_update: :cascade
  add_foreign_key "optional", "speciality", column: "optional_speciality", primary_key: "speciality_id", name: "optional_ibfk_1", on_update: :cascade
  add_foreign_key "optional_select", "optional", column: "optional_select_optional", primary_key: "optional_id", name: "optional_select_ibfk_2", on_update: :cascade
  add_foreign_key "optional_select", "student_group", column: "optional_select_student", primary_key: "student_group_id", name: "optional_select_ibfk_3"
  add_foreign_key "order", "template", column: "order_template", primary_key: "template_id", name: "order_ibfk_1", on_update: :cascade
  add_foreign_key "order_meta", "order", column: "order_meta_order", primary_key: "order_id", name: "order_meta_ibfk_1", on_update: :cascade
  add_foreign_key "order_reason", "order", column: "order_reason_order", primary_key: "order_id", name: "order_reason_ibfk_1", on_update: :cascade
  add_foreign_key "order_reason", "template_reason", column: "order_reason_reason", primary_key: "template_reason_id", name: "order_reason_ibfk_2", on_update: :cascade
  add_foreign_key "order_student", "order", column: "order_student_order", primary_key: "order_id", name: "order_student_ibfk_1", on_update: :cascade
  add_foreign_key "order_student", "student_group", column: "order_student_student_group_id", primary_key: "student_group_id", name: "order_student_ibfk_2"
  add_foreign_key "order_xsl", "template", column: "order_xsl_template", primary_key: "template_id", name: "order_xsl_ibfk_1", on_update: :cascade
  add_foreign_key "recalc", "student_group", column: "recalc_student_group", primary_key: "student_group_id", name: "recalc_ibfk_1"
  add_foreign_key "room", "flat", column: "room_flat", primary_key: "flat_id", name: "room_ibfk_1", on_update: :cascade
  add_foreign_key "speciality", "department", column: "speciality_faculty", primary_key: "department_id", name: "speciality_ibfk_1", on_update: :cascade
  add_foreign_key "speciality_payment", "student_group", column: "speciality_payment_student_group", primary_key: "student_group_id", name: "speciality_payment_ibfk_1"
  add_foreign_key "speciality_payment_type", "speciality", column: "speciality_payment_type_speciality", primary_key: "speciality_id", name: "speciality_payment_type_ibfk_1", on_update: :cascade
  add_foreign_key "speciality_price", "speciality_payment_type", column: "speciality_price_payment_type", primary_key: "speciality_payment_type_id", name: "speciality_price_ibfk_1", on_update: :cascade
  add_foreign_key "student_group", "group", column: "student_group_group", primary_key: "group_id", name: "student_group_ibfk_2", on_update: :cascade
  add_foreign_key "student_group", "student", column: "student_group_student", primary_key: "student_id", name: "student_group_ibfk_1", on_update: :cascade
  add_foreign_key "subdepartment", "department", column: "subdepartment_department", primary_key: "department_id", name: "subdepartment_ibfk_1", on_update: :cascade
  add_foreign_key "subject", "group", column: "subject_group", primary_key: "group_id", name: "subject_ibfk_1", on_update: :cascade
  add_foreign_key "teacher", "department", column: "teacher_department", primary_key: "department_id", name: "teacher_ibfk_2", on_update: :cascade
  add_foreign_key "teacher", "subdepartment", column: "teacher_subdepartment", primary_key: "subdepartment_id", name: "teacher_ibfk_1", on_update: :cascade
  add_foreign_key "template_cause", "template", column: "template_cause_template", primary_key: "template_id", name: "template_cause_ibfk_1", on_update: :cascade
  add_foreign_key "template_reason", "template", column: "template_reason_template", primary_key: "template_id", name: "template_reason_ibfk_1", on_update: :cascade
  add_foreign_key "user", "department", column: "user_department", primary_key: "department_id", name: "user_ibfk_1", on_update: :cascade
end
