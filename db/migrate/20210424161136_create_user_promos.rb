class CreateUserPromos < ActiveRecord::Migration[5.2]
  def change
    create_table :user_promos do |t|
      t.string :name
      t.string :promo_id
      t.boolean :active
      t.datetime :expires_at
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
