require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../factories'

describe Pubimage do
    it "should save ok with right name and url" do
     pubimage1 = FactoryGirl.create(:pubimage)
     expect(pubimage1.pimage.url).to eq("/uploads/images/sunshine.jpg")
     expect(pubimage1.name).to eq("sunshine.jpg")
  end
  it "should save ok with right pinyin name and url" do
     FactoryGirl.create(:pubimage)
     pubimage2 = FactoryGirl.create(:pubimage, pimage: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '美丽的sky.jpg')))
     expect(Pubimage.all.size).to eq(2)
     expect(pubimage2.pimage.url).to eq("/uploads/images/mei-li-de-sky.jpg")
     expect(pubimage2.name).to eq("美丽的sky.jpg")
  end

  it "should not valid with same file name" do
     FactoryGirl.create(:pubimage)
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage))).not_to be_valid
  end

  it "should not valid with out pimage" do
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage,pimage: ""))).not_to be_valid
  end
  it "should not valid with not image file" do
     expect(Pubimage.new(FactoryGirl.attributes_for(:pubimage,pimage:  Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'spec_helper.rb'))))).not_to be_valid
  end
end
