module TagHelper
  def linked_tag_list(tags)
    raw tags.collect {|tag| link_to(tag.name, posts_path(:tag => tag.name))}.join(", ")
  end
  def linked_category_list(categories)
    raw categories.collect {|category| link_to(category.name, posts_path(:category => category.name))}.join(", ")
  end
end
