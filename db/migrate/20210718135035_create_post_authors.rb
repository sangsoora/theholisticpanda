class CreatePostAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :post_authors do |t|
      t.string :first_name
      t.string :last_name
      t.string :description
      t.string :link
      t.references :practitioner, foreign_key: true

      t.timestamps
    end
  end
end
