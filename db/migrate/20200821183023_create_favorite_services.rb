class CreateFavoriteServices < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_services do |t|
      t.references :user, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
