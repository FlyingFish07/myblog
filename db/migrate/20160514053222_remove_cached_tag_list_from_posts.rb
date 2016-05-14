class RemoveCachedTagListFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :cached_tag_list, :string  
  end

  def down
    add_column :posts,  :cached_tag_list, :string
    Post.reset_column_information
    # next line makes ActsAsTaggableOn see the new column and create cache methods
    ActsAsTaggableOn::Taggable::Cache.included(Post)
    Post.find_each(:batch_size => 1000) do |p|
      p.tag_list # it seems you need to do this first to generate the list
      p.save!
    end    
  end
end
