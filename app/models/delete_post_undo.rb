class DeletePostUndo < UndoItem
  def process!
    post_attributes = loaded_data[:post]
    raise('Post already exists') if Post.find_by_id(post_attributes.delete('id').to_i)
    post = nil
    transaction do
      post = Post.create!(post_attributes)
      loaded_data[:comments].each do |comment|
        post.comments.create!(comment.except('id', 'post_id'))
      end
      self.destroy
    end
    post
  end

  def loaded_data
    @loaded_data ||= YAML.load(data)
  end

  def description
    "删除文章 '#{loaded_data[:post]["title"]}' 成功"
  end

  def complete_description
    "还原文章 '#{loaded_data[:post]["title"]}' 成功"
  end

  class << self
    def create_undo(post, user)
      # 由于还原后的post的id已经变了，所以tag、category也需要保存
      post_with_attributes = post.attributes
      post_with_attributes[:category_list] = post.category_list
      post_with_attributes[:tag_list] = post.category_list
      
      DeletePostUndo.create!(:data => {:post => post_with_attributes, :comments => post.comments.collect(&:attributes)}.to_yaml, :user => user)
    end
    def policy_class
      UndoItemPolicy
    end
  end
end
