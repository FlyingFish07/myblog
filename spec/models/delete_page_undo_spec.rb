require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe DeletePageUndo do
  describe '#process!' do
    it 'creates a new page based on the attributes stored in #data' do
      user = FactoryGirl.create(:admin)
      page = Page.create!(:title => 'a', :body => 'b')
      item = page.destroy_with_undo(user)
      new_page = item.process!
      expect(new_page.title).to eq('a')
    end
  end
end
