json.extract! employee, :id, :created_at, :updated_at, :name, :email, :title, :work_focus, :project_manager_id
json.url employee_url(employee, format: :json)
