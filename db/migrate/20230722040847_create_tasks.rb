class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :work_focus
      t.date :due_date
      t.integer :task_status_id
      t.integer :project_manager_id
      t.integer :employee_id
      t.integer :project_id
      t.string :mark_late_task_jid

      t.timestamps
    end

    add_index :tasks, :task_status_id
    add_index :tasks, :project_manager_id
    add_index :tasks, :employee_id
    add_index :tasks, :project_id

  end
end
