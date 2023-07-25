# Project Manager

## Getting started
This is a simple project management app that allows for two user roles of Project Manager and Employee. A project manager can create projects, create tasks for a project, and create sub tasks for a task. The project manager can also assign tasks and sub tasks to employees and track the status of the tasks.

Employees can view assigned tasks and update task status to working when ready to delevop. 

All views are gated behind a login and a JSON API for all CRUD actions is also available. 

To be able to run the app, you must install the required gems, create your database schema and seed the db:

```
bundle install
bundle exec rails db:migrate
bundle exec rails db:seed
```

Then start your server:

`bundle exec rails server`

and navigate to `http://localhost:30000`.

The database will be initialized with a single project manager user: email `admin@projectmanagerapp.com` and password: `password`. You will be able to login with these credentials and then create additional project managers and employees as desired.

## API

To use the API endpoints, simply append `.json` to the desired URL and pass all params and data as you would normally. To access gated resource via the API, you must include the `Authorization Bearer` header with your login token that is returned upon a successful login. E.g.

```
$ $ curl -X POST "http://localhost:3000/login_submit.json?email=admin@projectmanagementapp.com&password=password&role=ProjectManager"
{"login_key":"ProjectManager::l6XbUIJl3KFdUjgvxaWqJEsEb7WI6h8Y"}
$ curl -X GET -H 'Authorization: Bearer ProjectManager::l6XbUIJl3KFdUjgvxaWqJEsEb7WI6h8Y' http://localhost:3000/project_managers.json
[{"id":1,"created_at":"2023-07-25T04:40:46.319Z","updated_at":"2023-07-25T05:26:03.948Z","name":"Admin","email":"admin@projectmanagerapp.com","url":"http://localhost:3000/project_managers/1.json"},{"id":2,"created_at":"2023-07-25T05:27:01.533Z","updated_at":"2023-07-25T05:27:05.791Z","name":"Admin","email":"admin@projectmanagementapp.com","url":"http://localhost:3000/project_managers/2.json"}]
```

## Testing

First you must load your db schema into your trest database:

`bundle exec rails db:test:prepare`

Then simply run the tests in the `test/` directory.

`bundle exec rails test test/`


## Requirements

The idea is to create a simple project management dashboard with frontend as well as API access. The basic features should include the following:


Required models:
* Project Managers which would contain name, login email, login password
* Only Project Manager can create Employees
* Employees which would contain name, title, login email, and login password, work focus (ex: development, design, business, research, etc.)
* Tasks which would be assigned to the Employee(s) containing title, description, work focus, due date, status (not started, working, needs review, done, late), and Project Manager who created a Task
    * Tasks should be able to have sub tasks (the same model)
    * Only the assigned Project Manager to the Task can switch task to done status
    * Only the assigned Employee(s) can switch Task to working, and needs review statuses
* Only the Project Manager can create Tasks
* Projects which would contain Tasks (a Task can be assigned only to one Project), title, description, due date
    * Only the Project Manager can create Projects
* Add a recurring job (Sidekiq or any other solution of your choice), which would check the due date on Tasks and switch Tasks to "late" status if due date passed
* The frontend should have a workable UI (but simple, design doesn't matter), which would show Projects and perhaps columns for each Task status, where the Project Manager or Employee can manage with the features described above (you can use default RoR Haml views or React)
* There should be an API which would contain all of the above dashboard and frontend functionality
* There should be frontend and API functionality to login with an email and password as any of the Project Managers or Employees


Here are a couple of helpful hints to guide you along the way:

* Language/Framework. Please utilize Ruby on Rails as this is the primary tech stack for this position
* Practice TDD and SOLID principles
* PR rapport. Sometimes code doesn't require comments, but the PR does. It provides readers a guide as to how to approach the changes. How do you set up your team to make the best assessment of your code?
* Extra points for using React.js for frontend UI
* If you are running out of time, please focus on delivering high quality features instead of completing the whole thing
