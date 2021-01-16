class CreatePractitionerMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :practitioner_memberships do |t|
      t.string :name
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
