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

ActiveRecord::Schema.define(version: 20160909094939) do

  create_table "clazzs", force: :cascade do |t|
    t.string   "grade",      limit: 255,              comment: "年级"
    t.string   "number",     limit: 255,              comment: "班级号"
    t.integer  "room_id",    limit: 4,                comment: "班级所在的房间id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "teacher_id", limit: 4,   null: false, comment: "关联教师"
    t.integer  "student_id", limit: 4,   null: false, comment: "关联学生"
    t.string   "content",    limit: 255, null: false, comment: "评论内容"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "floors", force: :cascade do |t|
    t.string   "name",       limit: 255,                comment: "楼层名称"
    t.text     "image",      limit: 65535,              comment: "楼层cad图"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "payloads", force: :cascade do |t|
    t.integer  "student_id", limit: 4,             null: false, comment: "所属学生"
    t.integer  "station_id", limit: 4,             null: false, comment: "所属基站"
    t.integer  "strength",   limit: 4, default: 0,              comment: "信号强度"
    t.integer  "token",      limit: 4,                          comment: "当前数据组token"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string   "name",       limit: 255,                comment: "房间名称"
    t.text     "location",   limit: 65535,              comment: "房间坐标(相对楼层)"
    t.integer  "floor_id",   limit: 4,                  comment: "所属楼层id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string   "device_id",    limit: 255,                comment: "基站设备id"
    t.integer  "room_id",      limit: 4,                  comment: "所属房间/走道id"
    t.string   "group_number", limit: 255,                comment: "同一房间内的基站编号"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "location",     limit: 65535,              comment: "基站坐标"
  end

  create_table "sticker_configs", force: :cascade do |t|
    t.integer  "sticker_key", limit: 4
    t.string   "value",       limit: 255,              comment: "按键代表的评论内容"
    t.integer  "teacher_id",  limit: 4,                comment: "关联教师"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "name",       limit: 255,              comment: "学生姓名"
    t.string   "number",     limit: 255,              comment: "学号"
    t.string   "device_id",  limit: 255,              comment: "手环设备号"
    t.integer  "clazz_id",   limit: 4,                comment: "所属班级id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "gender",     limit: 255,              comment: "性别"
    t.string   "avatar",     limit: 255,              comment: "头像"
  end

  create_table "teachers", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,   null: false, comment: "关联用户"
    t.string   "name",       limit: 255, null: false, comment: "名字"
    t.string   "device_id",  limit: 255, null: false, comment: "教师手环设备号"
    t.string   "subject",    limit: 255,              comment: "学科"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 255,             null: false, comment: "用户名"
    t.string   "password",   limit: 255,             null: false, comment: "密码"
    t.integer  "permission", limit: 4,   default: 0,              comment: "权限bit"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "avatar",     limit: 255,                          comment: "头像"
  end

end
