class ModifyIndexForPubfileAndPubimage < ActiveRecord::Migration
  def change
    remove_index :pubfiles, :name
    add_index :pubfiles, [:user_id, :name], :unique => true

    remove_index :pubimages, :name
    add_index :pubimages, [:user_id, :name], :unique => true
  end
end
