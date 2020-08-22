class CreateFavoritePractitioners < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_practitioners do |t|
      t.references :user, foreign_key: true
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
