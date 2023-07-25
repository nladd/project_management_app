# Project Manager

The idea is to create a simple project management dashboard with frontend as well as API access. The basic features should include the following:


Required models:
* Project Managers which would contain name, login email, login password
* Only Project Manager can create Employees
* Employees which would contain name, title, login email, and login password, work focus (ex: development, design, business, research, etc.)
* Tasks which would be assigned to the Employee(s) containing title, description, work focus, due date, status (not started, working, needs review, done, late), and Project Manager who created a Task
** Tasks should be able to have sub tasks (the same model)
** Only the assigned Project Manager to the Task can switch task to done status
** Only the assigned Employee(s) can switch Task to working, and needs review statuses
* Only the Project Manager can create Tasks
* Projects which would contain Tasks (a Task can be assigned only to one Project), title, description, due date
** Only the Project Manager can create Projects
* Add a recurring job (Sidekiq or any other solution of your choice), which would check the due date on Tasks and switch Tasks to "late" status if due date passed
* The frontend should have a workable UI (but simple, design doesn't matter), which would show Projects and perhaps columns for each Task status, where the Project Manager or Employee can manage with the features described above (you can use default RoR Haml views or React)
* There should be an API which would contain all of the above dashboard and frontend functionality
* There should be frontend and API functionality to login with an email and password as any of the Project Managers or Employees


Here are a couple of helpful hints to guide you along the way:

Language/Framework. Please utilize Ruby on Rails as this is the primary tech stack for this position
Practice TDD and SOLID principles
PR rapport. Sometimes code doesn't require comments, but the PR does. It provides readers a guide as to how to approach the changes. How do you set up your team to make the best assessment of your code?
Extra points for using React.js for frontend UI
If you are running out of time, please focus on delivering high quality features instead of completing the whole thing