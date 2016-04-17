class CreatePubimages < ActiveRecord::Migration
  def change
    create_table :pubimages do |t|
      t.string :name
      t.string :pimage

      t.timestamps null: false
    end

    add_index :pubimages, :name, :unique => true
  end
end
