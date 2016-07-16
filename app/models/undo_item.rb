class UndoItem < ActiveRecord::Base
  belongs_to :user
  
  def process!
    raise("#process must be implemented by subclasses")
  end
end
