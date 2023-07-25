class CreateSubTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :sub_tasks do |t|
      t.string :title
      t.text :description
      t.string :work_focus
      t.date :due_date
      t.integer :task_status_id
      t.integer :employee_id
      t.integer :task_id
      t.string :mark_late_task_jid

      t.timestamps
    end

    add_index :sub_tasks, :task_status_id
    add_index :sub_tasks, :employee_id
    add_index :sub_tasks, :task_id
  end
end
