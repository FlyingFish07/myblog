class DeletePageUndo < UndoItem
  def process!
    raise('Page already exists') if Page.find_by_id(loaded_data.delete('id').to_i)

    page = nil
    transaction do
      page = Page.create!(loaded_data)
      self.destroy
    end
    page
  end

  def loaded_data
    @loaded_data ||= YAML.load(data)
  end

  def description
    "删除页面 '#{loaded_data['title']}' 成功"
  end

  def complete_description
    "还原页面 '#{loaded_data['title']}' 成功"
  end

  class << self
    def create_undo(page, user)
      DeletePageUndo.create!(:data => page.attributes.to_yaml, :user => user)
    end
    def policy_class
      UndoItemPolicy
    end
  end
end
