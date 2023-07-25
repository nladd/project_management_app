class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.date :due_date
      t.integer :project_manager_id

      t.timestamps
    end

    add_index :projects, :project_manager_id
  end
end
