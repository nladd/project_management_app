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

ActiveRecord::Schema[7.0].define(version: 2023_07_22_052737) do
  create_table "employees", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "login_key"
    t.string "title"
    t.string "work_focus"
    t.integer "project_manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_employees_on_email"
    t.index ["project_manager_id"], name: "index_employees_on_project_manager_id"
  end

  create_table "project_managers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.string "login_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_project_managers_on_email"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "due_date"
    t.integer "project_manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_manager_id"], name: "index_projects_on_project_manager_id"
  end

  create_table "sub_tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "work_focus"
    t.date "due_date"
    t.integer "task_status_id"
    t.integer "employee_id"
    t.integer "task_id"
    t.string "mark_late_task_jid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_sub_tasks_on_employee_id"
    t.index ["task_id"], name: "index_sub_tasks_on_task_id"
    t.index ["task_status_id"], name: "index_sub_tasks_on_task_status_id"
  end

  create_table "task_statuses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "work_focus"
    t.date "due_date"
    t.integer "task_status_id"
    t.integer "project_manager_id"
    t.integer "employee_id"
    t.integer "project_id"
    t.string "mark_late_task_jid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_tasks_on_employee_id"
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["project_manager_id"], name: "index_tasks_on_project_manager_id"
    t.index ["task_status_id"], name: "index_tasks_on_task_status_id"
  end

end
