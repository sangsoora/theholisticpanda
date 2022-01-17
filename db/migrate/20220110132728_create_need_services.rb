class CreateNeedServices < ActiveRecord::Migration[5.2]
  def change
    create_table :need_services do |t|
      t.integer :order
      t.references :need, foreign_key: true
      t.references :service, foreign_key: true

      t.timestamps
    end
  end
end
