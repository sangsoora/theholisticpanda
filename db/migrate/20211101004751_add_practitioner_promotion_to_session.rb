class AddPractitionerPromotionToSession < ActiveRecord::Migration[5.2]
  def change
    add_column :sessions, :practitioner_promotion, :boolean, :default => false
  end
end
