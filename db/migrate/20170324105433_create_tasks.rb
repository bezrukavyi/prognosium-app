class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :comment
      t.integer :position
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
