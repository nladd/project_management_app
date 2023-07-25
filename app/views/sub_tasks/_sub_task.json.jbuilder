json.extract! sub_task, :id, :created_at, :updated_at, :title, :description, :work_focus, :due_date, :task_status_id, :employee_id, :task_id
json.url sub_task_url(sub_task, format: :json)
