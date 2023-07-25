json.extract! project, :id, :created_at, :updated_at, :title, :description, :due_date, :project_manager_id
json.url project_url(project, format: :json)
