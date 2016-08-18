Given /I am logged in/ do
  FactoryGirl.create(:admin)
  visit '/admin/sign_in'
  within("#email-login") do
    fill_in 'Email', :with => 'admin@example.com'
    fill_in 'Password', :with => 'password'
    click_button '确认'
  end
end

Then /^the comment exists$/ do
  Comment.count.should == 2
end

Given /^the following comments? exists:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    FactoryGirl.create(:comment, hash)
  end
end

Given /^a comment exists with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.where(hash).should_not be_nil
  end
end

Given /^a comment does not exist with attributes:$/ do |comment_table|
  comment_table.hashes.each do |hash|
    Comment.where(hash).should be_nil
  end
end

Given /^I press icon button with title "(.*)"/ do |title|
  find(:xpath, "//label[@title='#{title}']").click
end

