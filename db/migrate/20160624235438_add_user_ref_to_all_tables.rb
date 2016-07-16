class AddUserRefToAllTables < ActiveRecord::Migration
  def change
    add_reference :posts, :user, index: true
    add_reference :pages, :user, index: true
    add_reference :pubfiles, :user, index: true
    add_reference :pubimages, :user, index: true
    add_reference :undo_items, :user, index: true
  end
end
