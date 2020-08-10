class CreateHealthGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :health_goals do |t|
      t.string :name

      t.timestamps
    end
  end
end
