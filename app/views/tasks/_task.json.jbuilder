json.extract! task, :id, :created_at, :updated_at, :title, :description, :work_focus, :due_date, :task_status_id, :project_manager_id, :employee_id, :project_id
json.url task_url(task, format: :json)
