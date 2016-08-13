require 'factory_girl'

# These factories are used by some rspec specs, as opposed
# to the ones used by cucumber which are defined elsewhere.
FactoryGirl.define do
  factory :user do 
    name 'user'
    sequence(:email, 1000) { |n| "user#{n}@example.com" }
    password 'password'
    role :user
  end

  factory :admin, class: User do 
    name 'admin'
    sequence(:email, 1000) { |n| "admin#{n}@example.com" }
    password 'password'
    role :admin
  end

  factory :post do
    user
    title                'My Post'
    body                 'hello this is my post'
    category_list        'red, green, blue'
    published_at_natural 'now'
    slug                 'my-manually-entered-slug'
    minor_edit           '0'
  end

  factory :comment do
    author       'Don Pseudonym'
    author_email 'donpseudonym@enkiblog.com'
    author_url   'http://enkiblog.com'
    body         'Not all those who wander are lost'
    post
  end

  factory :page do
    user
    title 'My page'
    slug  'my-manually-entered-slug'
    body  'hello this is my page'
  end

  factory :pubfile do
    user
    pfile { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'sunshine.jpg')) }
    description "it is very beautiful"
  end

  factory :pubimage do
    user
    pimage { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'sunshine.jpg')) }
  end
end
