class CreatePubfiles < ActiveRecord::Migration
  def change
    create_table :pubfiles do |t|
      t.string :name
      t.string :pfile
      t.string :description

      t.timestamps null: false
    end

    add_index :pubfiles, :name, :unique => true
  end
end
