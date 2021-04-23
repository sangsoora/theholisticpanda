class CreateReferredUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :referred_users do |t|
      t.string :email
      t.string :invite_token
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :referred_users, :invite_token, unique: true
  end
end
