Rails.application.routes.draw do
  resources :sub_tasks
  resources :project_managers
  resources :employees
  resources :tasks
  resources :projects2s
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "sessions#index"

  get '/employee-login', to: 'sessions#employee_login', as: :employee_login
  get '/project_manager-login', to: 'sessions#project_manager_login', as: :project_manager_login
  post '/login_submit', to: 'sessions#create', as: :login_submit
  get '/logout', to: 'sessions#destroy', as: :logout

  resources :projects
end
