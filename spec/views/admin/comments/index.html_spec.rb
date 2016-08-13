require File.dirname(__FILE__) + '/../../../spec_helper'

RSpec.configure do |c|
  c.include PunditMock
end

describe "/admin/comments/index.html" do
  before(:each) do 
    allow(view).to receive_message_chain(:policy,:update?).and_return(true)
  end

  after(:each) do
    expect(rendered).to be_valid_html5_fragment
  end

  it 'should render' do
    comments = [mock_model(Comment,
      :author     => 'Don Alias',
      :body       => 'Hello I am a post',
      :created_at => Time.now,
      :post_title => 'A Post',
      :post => mock_model(Post,
        :slug         => 'a-post',
        :published_at => Time.now
      )
    )]
    allow(comments).to receive(:total_pages).and_return(1)
    assign :comments, comments
    render :template => '/admin/comments/index', :formats => [:html]
  end
end
