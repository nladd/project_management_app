class CreateProjectManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :project_managers do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :login_key

      t.timestamps
    end

    add_index :project_managers, :email
  end
end
