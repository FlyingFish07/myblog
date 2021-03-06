require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe DeletePostUndo do
  describe '#process!' do
    it 'creates a new post with comments based on the attributes stored in #data' do
      user = FactoryGirl.create(:admin)
      post = Post.create!(:title => 'a', :body => 'b', :category_list => "test").tap do |in_post|
        in_post.comments.create!(:author => 'Don', :author_url => '', :author_email => 'don@dom.com', :body => 'comment')
      end
      item = post.destroy_with_undo(user)
      new_post = item.process!
      expect(new_post.comments.count).to eq(1)
    end
  end
end
