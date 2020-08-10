class CreateUserHealthGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :user_health_goals do |t|
      t.references :user, foreign_key: true
      t.references :health_goal, foreign_key: true

      t.timestamps
    end
  end
end
