class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :login_key
      t.string :title
      t.string :work_focus
      t.integer :project_manager_id

      t.timestamps
    end

    add_index :employees, :email
    add_index :employees, :project_manager_id
  end
end
