class CreateTaxRates < ActiveRecord::Migration[5.2]
  def change
    create_table :tax_rates do |t|
      t.string :name
      t.float :rate
      t.string :tax_id
      t.string :country_code

      t.timestamps
    end
  end
end
