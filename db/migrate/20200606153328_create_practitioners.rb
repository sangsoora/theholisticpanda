class CreatePractitioners < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioners do |t|
      t.string :location
      t.string :address
      t.text :bio
      t.string :video
      t.float :latitude
      t.float :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
