# mysql 5.6.4以上的版本支持分数精度(fractional seconds)，默认mysql精度只到秒，现在修改成6位精度 
class ChangeDatetimeLimitForMysql < ActiveRecord::Migration
  def up
    change_column :comments, :created_at, :datetime, limit: 6
    change_column :comments, :updated_at, :datetime, limit: 6

    change_column :omni_auth_details, :created_at, :datetime, limit: 6
    change_column :omni_auth_details, :updated_at, :datetime, limit: 6

    change_column :pages, :created_at, :datetime, limit: 6
    change_column :pages, :updated_at, :datetime, limit: 6

    change_column :posts, :created_at, :datetime, limit: 6
    change_column :posts, :updated_at, :datetime, limit: 6
    change_column :posts, :published_at, :datetime, limit: 6
    change_column :posts, :edited_at, :datetime, limit: 6

    change_column :pubfiles, :created_at, :datetime, limit: 6
    change_column :pubfiles, :updated_at, :datetime, limit: 6

    change_column :pubimages, :created_at, :datetime, limit: 6
    change_column :pubimages, :updated_at, :datetime, limit: 6

    change_column :sessions, :created_at, :datetime, limit: 6
    change_column :sessions, :updated_at, :datetime, limit: 6

    change_column :taggings, :created_at, :datetime, limit: 6

    change_column :undo_items, :created_at, :datetime, limit: 6
  end
  
  def down
    change_column :comments, :created_at, :datetime
    change_column :comments, :updated_at, :datetime

    change_column :omni_auth_details, :created_at, :datetime
    change_column :omni_auth_details, :updated_at, :datetime

    change_column :pages, :created_at, :datetime
    change_column :pages, :updated_at, :datetime

    change_column :posts, :created_at, :datetime
    change_column :posts, :updated_at, :datetime
    change_column :posts, :published_at, :datetime
    change_column :posts, :edited_at, :datetime

    change_column :pubfiles, :created_at, :datetime
    change_column :pubfiles, :updated_at, :datetime

    change_column :pubimages, :created_at, :datetime
    change_column :pubimages, :updated_at, :datetime

    change_column :sessions, :created_at, :datetime
    change_column :sessions, :updated_at, :datetime

    change_column :taggings, :created_at, :datetime

    change_column :undo_items, :created_at, :datetime
  end
end
