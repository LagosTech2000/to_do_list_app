class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.datetime :dueDate
      t.string :status
      t.timestamps
    end
  end
end
