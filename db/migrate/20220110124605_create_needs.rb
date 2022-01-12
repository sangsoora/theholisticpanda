class CreateNeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :needs do |t|
      t.string :name

      t.timestamps
    end
  end
end
