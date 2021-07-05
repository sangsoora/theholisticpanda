class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :short_title
      t.boolean :published
      t.string :author
      t.text :body
      t.string :link
      t.references :post_category, foreign_key: true

      t.timestamps
    end
  end
end
