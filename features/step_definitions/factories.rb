require 'factory_girl'

FactoryGirl.define do
  factory :tag, :class => ActsAsTaggableOn::Tag do
    name 'Tag'
  end

  factory :post do
    title     'A post'
    slug      'a-post'
    body      'This is a post'
    category_list 'red, green, blue'

    published_at { 1.day.ago }
    created_at   { 1.day.ago }
    updated_at   { 1.day.ago }
  end

  factory :comment do
    author       'Don Alias'
    author_email 'enki@enkiblog.com'
    author_url   'http://enkiblog.com'
    body         'I find this article thought provoking'
    association :post
  end
  
  factory :user do 
    name 'user'
    email 'user@example.com'
    password 'password'
    role :user
  end

  factory :admin, class: User do 
    name 'admin'
    email 'admin@example.com'
    password 'password'
    role :admin
  end
end