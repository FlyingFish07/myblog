require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe Pubimage do
    it "should save ok with right name and url" do
     pubimage = FactoryGirl.create(:pubimage)
     expect(pubimage.pimage.url).to eq("/uploads/images/#{pubimage.user.id}/sunshine.jpg")
     expect(pubimage.name).to eq("sunshine.jpg")
  end
  it "should save ok with right pinyin name and url" do
     FactoryGirl.create(:pubimage)
     pubimage = FactoryGirl.create(:pubimage, pimage: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
     expect(Pubimage.all.size).to eq(2)
     expect(pubimage.pimage.url).to eq("/uploads/images/#{pubimage.user.id}/mei-li-de-sky.jpg")
     expect(pubimage.name).to eq("美丽的sky.jpg")
  end

  it "should not valid with same file name" do
     pubimage = FactoryGirl.create(:pubimage)
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage).merge!({:user_id => pubimage.user_id}))).not_to be_valid
  end

  it "should not valid with out pimage" do
     pubimage = FactoryGirl.create(:pubimage)
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage,pimage: "").merge!({:user_id => pubimage.user_id}))).not_to be_valid
  end
  it "should not valid with not image file" do
     pubimage = FactoryGirl.create(:pubimage)
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage,pimage:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb'))).merge!({:user_id => pubimage.user_id}))).not_to be_valid
  end
end
