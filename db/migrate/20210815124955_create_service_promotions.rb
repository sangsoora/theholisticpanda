class CreateServicePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :service_promotions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :discount_percentage
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
