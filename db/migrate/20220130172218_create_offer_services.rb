class CreateOfferServices < ActiveRecord::Migration[5.2]
  def change
    create_table :offer_services do |t|
      t.integer :order
      t.references :offer, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
