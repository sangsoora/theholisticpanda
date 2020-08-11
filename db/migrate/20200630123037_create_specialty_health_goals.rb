class CreateSpecialtyHealthGoals < ActiveRecord::Migration[5.2]
  def change
    create_table :specialty_health_goals do |t|
      t.references :specialty, foreign_key: true
      t.references :health_goal, foreign_key: true

      t.timestamps
    end
  end
end
